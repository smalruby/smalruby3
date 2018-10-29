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
  class Sprite
    ROTATION_STYLE = {
      all_around: "all around",
      left_right: "left-right",
      none: "don't rotate",
    }

    attr_accessor :name
    attr_reader :x
    attr_reader :y
    attr_reader :direction
    attr_accessor :visible
    attr_accessor :size
    attr_reader :current_costume
    attr_reader :costumes
    attr_reader :rotation_style
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
      @x = 0
      @y = 0
      @costumes = []

      @vector = { x: 1, y: 0 }
      @event_handlers = {}
      @threads = []
      @name_to_costume = {}
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

    def position
      [x, y]
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

    def rotation_style=(val)
      @rotation_style = val
      sync_direction
    end

    def draw
      if @visible
        @dxruby_sprite.draw
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
      angle = s2dx.angle(direction)

      radian = angle * Math::PI / 180
      @vector[:x] = Math.cos(radian)
      @vector[:y] = -Math.sin(radian)

      case @rotation_style
      when ROTATION_STYLE[:all_around]
        @dxruby_sprite.scale_x = 1
        @dxruby_sprite.angle = angle
      when ROTATION_STYLE[:left_right]
        if @vector[:x] >= 0
          @dxruby_sprite.scale_x = 1
        else
          @dxruby_sprite.scale_x = -1
        end
        @dxruby_sprite.angle = 0
      when ROTATION_STYLE[:none]
        @dxruby_sprite.scale_x = 1
        @dxruby_sprite.angle = 0
      end
    end

    def sync_costumes
      @dxruby_sprite.image = @costumes[@current_costume]
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
