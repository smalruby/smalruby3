module Smalruby3
  module SpriteMethod
    module Sensing
      def touching?(object)
        case object
        when "_edge_"
          x <= SmalrubyToDXRuby::SCREEN_LEFT || x >= SmalrubyToDXRuby::SCREEN_RIGHT ||
            y <= SmalrubyToDXRuby::SCREEN_BOTTOM || y >= SmalrubyToDXRuby::SCREEN_TOP
        when "_mouse_"
          dx_mouse_x = Input.mousePosX
          dx_mouse_y = Input.mousePosY
          mouse_x, mouse_y = *dx2s.position(dx_mouse_x, dx_mouse_y)
          x + costume.width / 2 >= mouse_x && x - costume.width / 2 <= mouse_x &&
            y - costume.height / 2 <= mouse_y && y + costume.height / 2 >= mouse_y
        else
          if !sprite(object)
            raise ArgumentError, "invalid object: #{object}"
          end
        end
      end
    end
  end
end
