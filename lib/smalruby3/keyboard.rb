module Smalruby3
  class Keyboard
    class << self
      def pressed?(key)
        raise NotImplementedError, "need to define `rewind'"
      end
    end
  end
end