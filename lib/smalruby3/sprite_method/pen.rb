module Smalruby3
  module SpriteMethod
    # Pen category methods
    module Pen
      def clear
        world.current_stage.clear
      end

      def down_pen
        @enable_pen = true
      end

      def up_pen
        @enable_pen = false
      end

      # set pen color
      #
      # @param [Array<Integer>|Symbol|Integer] val color
      #   When color is Array<Integer>, it means [R, G, B].
      #   When color is Symbol, it means the color code; like :white, :black, etc...
      #   When color is Integer, it means hue.
      def pen_color=(val)
        if val.is_a?(Numeric)
          val %= 201
          _, s, l = Color.rgb_to_hsl(*pen_color)
          val = Color.hsl_to_rgb(val, s, l)
        end
        @pen_color = val
      end

      # change pen color
      #
      # @param [Integer] val color
      def change_pen_color_by(val)
        h, s, l = Color.rgb_to_hsl(*pen_color)
        @pen_color = Color.hsl_to_rgb(h + val, s, l)
      end

      # set pen shade
      #
      # @param Integer val shade
      def pen_shade=(val)
        val %= 101
        h, s, = *Color.rgb_to_hsl(*pen_color)
        @pen_color = Color.hsl_to_rgb(h, s, val)
      end
    end
  end
end
