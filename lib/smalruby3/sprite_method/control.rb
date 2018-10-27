module Smalruby3
  module SpriteMethod
    # Control category methods
    module Control
      def loop
        Kernel.loop do
          yield
          Smalruby3.await
        end
      end

      def await
        Smalruby3.await
      end
    end
  end
end
