module Smalruby3
  module SpriteMethod
    # Looks category methods
    module Looks
      def say(message, second = nil)
        # コンソール上にmessageの表示
        puts message, second.inspect
      end
    end
  end
end
