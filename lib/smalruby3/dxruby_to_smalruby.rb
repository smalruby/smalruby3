require_relative "util"

module Smalruby3
  class DXRubyToSmalruby
    SCREEN_BOTTOM = -180
    SCREEN_LEFT = -240

    attr_reader :scale

    def initialize(options = {})
      defaults = {
        scale: 1,
      }
      opts = Util.process_options(options, defaults)
      opts.each do |k, v|
        send("#{k}=", v)
      end
    end

    def scale=(val)
      @scale = val.to_f
    end

    def x(pos_x)
      (pos_x / @scale + SCREEN_LEFT).ceil
    end

    def y(pos_y)
      -(pos_y / @scale + SCREEN_BOTTOM).ceil
    end

    def position(pos_x, pos_y)
      [x(pos_x), y(pos_y)]
    end
  end
end
