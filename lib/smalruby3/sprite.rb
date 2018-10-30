require_relative "util"
require_relative "world"
require_relative "event_handler"
require_relative "costume"
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
      @current_costume = 0

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

      World.instance.add_target(self)

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
        c = Costume.new(asset)
        @name_to_costume[c.name] = c
        c
      }
      sync_costumes
    end

    def current_costume=(index)
      @current_costume = if @costumes.length > 0
                           index % @costumes.length
                         else
                           0
                         end
      sync_costumes
    end

    def costume
      @costumes[@current_costume]
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

    def s2dx
      World.instance.s2dx
    end

    def sync_position
      dx_x, dx_y = *s2dx.position(x, y)
      if (c = costume)
        dx_x -= c.rotation_center_x
        dx_y -= c.rotation_center_y
      end
      @dxruby_sprite.x = dx_x
      @dxruby_sprite.y = dx_y
    end

    def sync_direction
      angle = s2dx.angle(direction)

      radian = angle * Math::PI / 180
      @vector[:x] = Math.cos(radian)
      @vector[:y] = -Math.sin(radian)

      scale_x = (c = costume) ? c.width_scale : 1
      case @rotation_style
      when ROTATION_STYLE[:all_around]
        @dxruby_sprite.scale_x = scale_x
        @dxruby_sprite.angle = angle
      when ROTATION_STYLE[:left_right]
        @dxruby_sprite.scale_x = if @vector[:x] >= 0
                                   scale_x
                                 else
                                   -scale_x
                                 end
        @dxruby_sprite.angle = 0
      when ROTATION_STYLE[:none]
        @dxruby_sprite.scale_x = scale_x
        @dxruby_sprite.angle = 0
      end
    end

    def sync_costumes
      if (c = costume)
        @dxruby_sprite.image = c.image
        @dxruby_sprite.scale_x = c.width_scale
        @dxruby_sprite.scale_y = c.height_scale
        @dxruby_sprite.center_x = c.rotation_center_x
        @dxruby_sprite.center_y = c.rotation_center_y
      end
      sync_position
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
