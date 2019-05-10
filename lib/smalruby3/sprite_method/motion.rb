require_relative "../dxruby_to_smalruby"

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
        new_pos = convert_position(destination)
        self.position = new_pos
        direction
      end

      def glide(destination, secs: 1)
        fps = 60.0
        wait_seconds = 1 / fps
        roop_count = (secs * fps).round
        new_pos = convert_position(destination)
        diffrence_x = (new_pos[0] - x) / roop_count.to_f
        diffrence_y = (new_pos[1] - y) / roop_count.to_f
        roop_count.times do
          self.x += diffrence_x
          self.y += diffrence_y
          sleep(wait_seconds)
        end
        self.position = new_pos
      end

      def direction=(degrees)
        @direction = calc_direction(degrees)

        sync_direction
      end

      def point_towards(towards)
        tx = sprite(towards).x
        ty = sprite(towards).y
        dx = tx - x
        dy = ty - y
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

      def calc_mouse_position
        dx_mouse_x = Input.mousePosX
        dx_mouse_y = Input.mousePosY
        dx_ruby_to_smalruby = DXRubyToSmalruby.new
        dx_ruby_to_smalruby.position(dx_mouse_x, dx_mouse_y)
      end

      def convert_position(position)
        if position == "_random_"
          new_x = rand(SmalrubyToDXRuby::SCREEN_LEFT..SmalrubyToDXRuby::SCREEN_RIGHT)
          new_y = rand(SmalrubyToDXRuby::SCREEN_BOTTOM..SmalrubyToDXRuby::SCREEN_TOP)
          new_pos = [new_x, new_y]
        elsif position == "_mouse_"
          new_pos = calc_mouse_position
        elsif position.is_a?(Array)
          new_pos = position
        end
        new_pos
      end
    end
  end
end
