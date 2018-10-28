require "forwardable"
require "mutex_m"

require_relative "util"
require_relative "world"
require_relative "event_handler"
require_relative "sprite_method"
require_relative "sprite_method/motion"
require_relative "sprite_method/looks"
require_relative "sprite_method/sound"
require_relative "sprite_method/events"
require_relative "sprite_method/control"
require_relative "sprite_method/sensing"
require_relative "sprite_method/operations"
require_relative "sprite_method/variables"
require_relative "sprite_method/my_blocks"
require_relative "sprite_method/pen"

module Smalruby3
  # Sprite class
  class Sprite
    extend Forwardable

    ROTATION_STYLE = {
      all_around: "all around",
      left_right: "left-right",
      none: "don't rotate",
    }

    @@font_cache = {}
    @@font_cache.extend(Mutex_m)

    @@sound_cache = {}
    @@sound_cache.extend(Mutex_m)

    attr_accessor :name
    attr_accessor :x
    attr_accessor :y
    attr_reader :direction
    attr_accessor :visible
    attr_accessor :size
    attr_accessor :current_costume
    attr_reader :costumes
    attr_accessor :rotation_style
    attr_accessor :variables
    attr_accessor :lists

    attr_accessor :event_handlers
    attr_accessor :threads
    attr_accessor :is_stage

    attr_accessor :checking_hit_targets
    attr_reader :enable_pen
    attr_accessor :pen_color
    attr_accessor :volume

    def initialize(name, options = {}, &block)
      @name = name
      @vector = { x: 1, y: 0 }
      @event_handlers = {}
      @threads = []
      @name_to_costume = {}
      @costumes = []
      @is_stage = false

      @dxruby_sprite = DXRuby::Sprite.new(0, 0)

      defaults = {
        x: 0,
        y: 0,
        direction: 90,
        visible: true,
        size: 100,
        current_costume: 0,
        costumes: [],
        rotation_style: ROTATION_STYLE[:all_around],
        variables: [],
        lists: [],
      }
      opts = Util.process_options(options, defaults)
      opts.each do |k, v|
        send("#{k}=", v)
      end

      world.add_target(self)

      if block_given?
        instance_eval(&block)
      end
    end

    def costumes=(assets)
      @name_to_costume = {}
      @costumes = assets.map { |asset|
        costume = DXRuby::Image.load(world.asset_path(asset))
        @name_to_costume[asset[:name]] = costume
        costume
      }
      sync_costumes
    end

    def current_costume=(index)
      if @costumes.length > 0
        @current_costume = index % @costumes.length
      else
        @current_costume = 0
      end
      sync_costumes
    end

    def draw
      if @visible
        @dxruby_sprite.draw
      end
    end

    def on(event, *options, &block)
      event = event.to_sym
      @event_handlers[event] ||= []
      h = EventHandler.new(self, options, &block)
      @event_handlers[event] << h

      case event
      when :start
        @threads << h.call if Smalruby.started?
      when :hit
        @checking_hit_targets << options
        @checking_hit_targets.flatten!
        @checking_hit_targets.uniq!
      end
    end

    def start
      @event_handlers[:start].try(:each) do |h|
        @threads << h.call
      end
    end

    def key_down(keys)
      @event_handlers[:key_down].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |k| keys.include?(k) }
          next
        end
        @threads << h.call
      end
    end

    def key_push(keys)
      @event_handlers[:key_push].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |k| keys.include?(k) }
          next
        end
        @threads << h.call
      end
    end

    def click(buttons)
      @event_handlers[:click].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |b| buttons.include?(b) }
          next
        end
        @threads << h.call(Input.mouse_pos_x, Input.mouse_pos_y)
      end
    end

    def hit
      # TODO: なんでもいいからキャラクターに当たった場合に対応する
      @checking_hit_targets &= World.instance.objects
      objects = check(@checking_hit_targets)
      return if objects.empty?
      @event_handlers[:hit].try(:each) do |h|
        if h.options.length > 0 && !h.options.any? { |o| objects.include?(o) }
          next
        end
        @threads << h.call(h.options & objects)
      end
    end

    def fire(event, *options)
      if (events = @event_handlers[event])
        events.each do |e|
          if e.options == options
            @threads << e.call
          end
        end
      end
    end

    def join_threads(wait = false)
      @threads.compact!
      error = false
      @threads.delete_if { |t|
        if t.alive?
          false
        else
          begin
            t.join
          rescue => e
            Util.print_exception(e)
            error = true
          end
          true
        end
      }
      if error
        exit(1)
      end
      if wait
        @threads.each(&:join)
      end
    end

    private

    def world
      Smalruby3.world
    end

    def s2dx
      world.s2dx
    end

    def sync_position
      @dxruby_sprite.x, @dxruby_sprite.y = s2dx.position(x, y)
    end

    def sync_direction
      degrees = (direction - 90) % 360
      radian = degrees * Math::PI / 180
      @vector[:x] = Math.cos(radian)
      @vector[:y] = Math.sin(radian)
    end

    def sync_costumes
      @dxruby_sprite.image = @costumes[@current_costume]
    end

    def draw_pen(left, top, right, bottom)
      return if Util.raspberrypi? || !visible || vanished?
      world.current_stage.line(left: left, top: top,
                               right: right, bottom: bottom,
                               color: @pen_color)
    end

    def sync_angle(x, y)
      a = Math.acos(x / Math.sqrt(x**2 + y**2)) * 180 / Math::PI
      a = 360 - a if y < 0
      self.angle = a
    end

    def new_font(size)
      @@font_cache.synchronize do
        @@font_cache[size] ||= DXRuby::Font.new(size)
      end
      @@font_cache[size]
    end

    def new_sound(name)
      @@sound_cache.synchronize do
        @@sound_cache[name] ||= DXRuby::Sound.new(asset_path(name))
      end
      @@sound_cache[name]
    end

    def draw_balloon
      if @balloon
        @balloon.x = x + image.width / 2
        if @balloon.x < 0
          @balloon.x = 0
        elsif @balloon.x + @balloon.image.width >= DXRuby::Window.width
          @balloon.x = DXRuby::Window.width - @balloon.image.width
        end
        @balloon.y = y - @balloon.image.height
        if @balloon.y < 0
          @balloon.y = 0
        elsif @balloon.y + @balloon.image.height >= DXRuby::Window.height
          @balloon.y = DXRuby::Window.height - @balloon.image.height
        end
        @balloon.draw
      end
    end

    def calc_volume
      (255 * @volume / 100.0).to_i
    end

    include SpriteMethod::Motion
    include SpriteMethod::Looks
    include SpriteMethod::Sound
    include SpriteMethod::Events
    include SpriteMethod::Control
    include SpriteMethod::Sensing
    include SpriteMethod::Operations
    include SpriteMethod::Variables
    include SpriteMethod::MyBlocks
    include SpriteMethod::Pen
  end
end
