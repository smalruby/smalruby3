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
        d = degrees % 360
        if d > 180
          d -= 360
        end
        @direction = d
        sync_direction
      end

      def x=(new_x)
        if new_x < -240
          new_x = -240
        elsif new_x > 240
          new_x = 240
        end
        @x = new_x

        sync_position
      end

      def y=(new_y)
        if new_y < -160
          new_y = -160
        elsif new_y > 160
          new_y = 160
        end
        @y = new_y

        sync_position
      end

      def position=(val)
        new_x, new_y = *val
        if new_x < -240
          new_x = -240
        elsif new_x > 240
          new_x = 240
        end
        @x = new_x

        if new_y < -160
          new_y = -160
        elsif new_y > 160
          new_y = 160
        end
        @y = new_y

        sync_position
      end

      def position
        [x, y]
      end

      def turn
        sync_angle(@vector[:x] * -1, @vector[:y] * -1)
      end

      def turn_x
        sync_angle(@vector[:x] * -1, @vector[:y])
      end

      def turn_y
        sync_angle(@vector[:x], @vector[:y] * -1)
      end

      def turn_if_reach_wall
        lr = reach_left_or_right_wall?
        tb = reach_top_or_bottom_wall?
        if lr && tb
          turn
        elsif lr
          turn_x
        elsif tb
          turn_y
        end
      end

      def rotation_style=(val)
        @rotation_style = val
        sync_angle(@vector[:x], @vector[:y])
      end

      def angle
        return super if @rotation_style == :free

        x, y = @vector[:x], @vector[:y]
        a = Math.acos(x / Math.sqrt(x**2 + y**2)) * 180 / Math::PI
        a = 360 - a if y < 0
        a
      end

      def angle=(val)
        val %= 360
        radian = val * Math::PI / 180
        @vector[:x] = Math.cos(radian)
        @vector[:y] = Math.sin(radian)

        if @rotation_style == :free
          self.scale_x = scale_x.abs
          super(val)
        elsif @rotation_style == :left_right
          if @vector[:x] >= 0
            self.scale_x = scale_x.abs
          else
            self.scale_x = scale_x.abs * -1
          end
          super(0)
        else
          self.scale_x = scale_x.abs
          super(0)
        end
      end

      def point_towards(target)
        if target == :mouse
          tx = DXRuby::Input.mouse_pos_x
          ty = DXRuby::Input.mouse_pos_y
        else
          tx = target.x
          ty = target.y
        end
        dx = tx - x
        dy = ty - y
        self.angle = Math.atan2(dy, dx) * 180 / Math::PI
      end

      def go_to(target)
        if target == :mouse
          x = DXRuby::Input.mouse_pos_x - center_x
          y = DXRuby::Input.mouse_pos_y - center_y
        else
          x = target.x
          y = target.y
        end
        self.position = [x, y]
      end
    end
  end
end
