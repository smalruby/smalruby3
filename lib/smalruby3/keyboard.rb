module Smalruby3
  class Keyboard
    class << self
      def pressed?(key)
        if key == "any"
          !Input.keys.empty?
        else
          Input.key_down?(to_dxruby_key(key))
        end
      end

      def to_dxruby_key(key)
        if key == "space"
          return DXRuby.const_get("K_SPACE")
        end
        if /^(up|down|right|left) arrow$/ =~ key
          return DXRuby.const_get("K_" + $1.upcase)
        end
        if /^[a-z]$/ =~ key
          return DXRuby.const_get("K_" + key.upcase)
        end
        if /[0-9]/ =~ key
          return DXRuby.const_get("K_" + key)
        end
        raise ArgumentError.new("invalid key: #{key}")
      end
    end
  end
end
