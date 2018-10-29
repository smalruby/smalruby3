require_relative "util"

module Smalruby3
  class SmalrubyToDXRuby
    SCREEN_TOP = 180
    SCREEN_BOTTOM = -180
    SCREEN_LEFT = -240
    SCREEN_RIGHT = 240

    attr_reader :window_width
    attr_reader :window_height
    attr_accessor :fps

    def initialize(options = {})
      defaults = {
        window_width: screen_width * 2,
        window_height: screen_height * 2,
        fps: 10,
      }
      opts = Util.process_options(options, defaults)
      opts.each do |k, v|
        send("#{k}=", v)
      end
    end

    def window_width=(val)
      @window_width = val
      @window_width_ratio = val.to_f / screen_width
    end

    def window_height=(val)
      @window_height = val
      @window_height_ratio = val.to_f / screen_height
    end

    def x(pos_x)
      ((pos_x - SCREEN_LEFT) * @window_width_ratio).ceil
    end

    def y(pos_y)
      ((-pos_y - SCREEN_BOTTOM) * @window_height_ratio).ceil
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
