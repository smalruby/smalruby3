module Smalruby3
  module SpriteMethod
    # Sensing category methods
    module Sensing
      def touching?(object)
        case object
        when "_edge_"
          # TODO: check with rotation_center_{x,y}, costume {width,height}, costume transparent
          x <= SmalrubyToDXRuby::SCREEN_LEFT || x >= SmalrubyToDXRuby::SCREEN_RIGHT ||
            y <= SmalrubyToDXRuby::SCREEN_BOTTOM || y >= SmalrubyToDXRuby::SCREEN_TOP
        when "_mouse_"
          # TODO: check touching mouse
          raise NotImplementedError, "touching?(\"#{object}\")"
        else
          if !sprite(object)
            # TODO: check touching sprite
            raise ArgumentError, "invalid object: #{object}"
          end
        end
      end
    end
  end
end
