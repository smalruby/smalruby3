module Smalruby3
  class Keyboard
    class << self
      def pressed?(key)
        smalruby_key = key
        if (smalruby_key == "up arrow")
          dxruby_key = DXRuby::K_UP
        end
        if (smalruby_key == "down arrow")
          dxruby_key = DXRuby::K_DOWN
        end
        if (smalruby_key == "right arrow")
          dxruby_key = DXRuby::K_RIGHT
        end
        if (smalruby_key == "left arrow")
          dxruby_key = DXRuby.const_get("K_LEFT")
        end
        if (smalruby_key == "space")
          dxruby_key = DXRuby.const_get("K_SPACE")
        end
        smalruby_key == "a"
        if /^[a-z]$/ =~ smalruby_key
          dxruby_key = DXRuby.const_get("K_" + smalruby_key.upcase)
        end
        if /[0-9]/ =~ smalruby_key
          dxruby_key = DXRuby.const_get("K_" + smalruby_key)
        end
        if  (smalruby_key == "any")
          !Input.keys.empty?
        else
          Input.key_down?(dxruby_key)
        end
      end
    end
  end
end