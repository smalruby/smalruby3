require_relative "util"

module Smalruby3
  class SmalrubyToDXRuby
    SCREEN_TOP = 160
    SCREEN_BOTTOM = -160
    SCREEN_LEFT = -240
    SCREEN_RIGHT = 240

    attr_accessor :window_width
    attr_accessor :window_height

    def initialize(options = {})
      defaults = {
        window_width: 480 * 2,
        window_height: 320 * 2,
      }
      opts = Util.process_options(options, defaults)
      opts.each do |k, v|
        send("#{k}=", v)
      end
    end

    def x(pos_x)
      ((pos_x - SCREEN_LEFT) * window_width.to_f / (SCREEN_RIGHT - SCREEN_LEFT)).ceil
    end

    def y(pos_y)
      ((-pos_y - SCREEN_BOTTOM) * window_height.to_f / (SCREEN_TOP - SCREEN_BOTTOM)).ceil
    end

    def position(pos_x, pos_y)
      [self.x(pos_x), self.y(pos_y)]
    end
  end
end
