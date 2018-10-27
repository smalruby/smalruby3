module Smalruby3
  module SpriteMethod
    # Sensing category methods
    module Sensing
      def distance(x, y)
        Math.sqrt((self.x + center_x - x).abs**2 +
          (self.y + center_y - y).abs**2).to_i
      end

      def reach_wall?
        reach_left_or_right_wall? || reach_top_or_bottom_wall?
      end

      def reach_left_or_right_wall?
        x <= 0 || x >= (DXRuby::Window.width - image.width)
      end

      def reach_top_or_bottom_wall?
        y <= 0 || y >= (DXRuby::Window.height - image.height)
      end

      def hit?(other)
        check([other]).length > 0
      end
    end
  end
end
