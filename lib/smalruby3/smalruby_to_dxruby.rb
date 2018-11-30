require_relative "util"

module Smalruby3
  class SmalrubyToDXRuby
    SCREEN_TOP = 180
    SCREEN_BOTTOM = -180
    SCREEN_LEFT = -240
    SCREEN_RIGHT = 240

    attr_reader :scale
    attr_accessor :fps
    attr_reader :window_width
    attr_reader :window_height

    def initialize(options = {})
      defaults = {
        scale: 2,
        fps: 15,
      }
      opts = Util.process_options(options, defaults)
      opts.each do |k, v|
        send("#{k}=", v)
      end
    end

    def scale=(val)
      @scale = val.to_f
      @window_width = (screen_width * @scale).ceil
      @window_height = (screen_height * @scale).ceil
    end

    def x(pos_x)
      ((pos_x - SCREEN_LEFT) * @scale).ceil
    end

    def y(pos_y)
      ((-pos_y - SCREEN_BOTTOM) * @scale).ceil
    end

    def position(pos_x, pos_y)
      [x(pos_x), y(pos_y)]
    end

    def screen_width
      SCREEN_RIGHT - SCREEN_LEFT
    end

    def screen_height
      SCREEN_TOP - SCREEN_BOTTOM
    end

    def angle(direction)
      (direction - 90) % 360
    end
  end
end
