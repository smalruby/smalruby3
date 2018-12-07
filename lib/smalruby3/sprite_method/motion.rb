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
      
      def turn_left(degrees)
        turn_right(-degrees)
      end
      
      def go_to(destination)
        if destination == "_random_"
          self.x = rand(SmalrubyToDXRuby::SCREEN_LEFT..SmalrubyToDXRuby::SCREEN_RIGHT)
          self.y = rand(SmalrubyToDXRuby::SCREEN_BOTTOM..SmalrubyToDXRuby::SCREEN_TOP)
        end
        direction
      end

      def direction=(degrees)
        @direction = calc_direction(degrees)

        sync_direction
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
