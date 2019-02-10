module Smalruby3
  module SpriteMethod
    # Motion category methods
    module Motion
      def move(steps)
        self.position = [x + @vector[:x] * steps, y + @vector[:y] * steps]
        position
      end

      def turn_right(degrees)
        self.direction += degrees
        direction
      end

      def direction=(degrees)
        @direction = calc_direction(degrees)

        sync_direction
      end

      def point_towards(towards) # 対象物に対して体を向ける
        tx = sprite(towards).x
        ty = sprite(towards).y
        dx = tx-x
        dy = ty-y
        rad = Math.atan2(dx, dy)
        self.direction = rad * 180.0 / Math::PI
      end
      
      def x=(val)
        @x = calc_x(val)

        sync_position
      end

      def y=(val)
        @y = calc_y(val)

        sync_position
      end

      def position=(val)
        @x = calc_x(val[0])
        @y = calc_y(val[1])

        sync_position
      end

      private

      def calc_x(val)
        if val < SmalrubyToDXRuby::SCREEN_LEFT
          SmalrubyToDXRuby::SCREEN_LEFT
        elsif val > SmalrubyToDXRuby::SCREEN_RIGHT
          SmalrubyToDXRuby::SCREEN_RIGHT
        else
          val
        end
      end

      def calc_y(val)
        if val < SmalrubyToDXRuby::SCREEN_BOTTOM
          SmalrubyToDXRuby::SCREEN_BOTTOM
        elsif val > SmalrubyToDXRuby::SCREEN_TOP
          SmalrubyToDXRuby::SCREEN_TOP
        else
          val
        end
      end

      def calc_direction(degrees)
        d = degrees % 360
        if d > 180
          d -= 360
        end
        d
      end
    end
  end
end
