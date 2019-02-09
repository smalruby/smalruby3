module Smalruby3
  module SpriteMethod
    # Events category methods
    module Events
      def when(event, *options, &block)
        event = event.to_sym
        @event_handlers[event] ||= []
        h = EventHandler.new(self, options, &block)
        @event_handlers[event] << h
      end
      
      def broadcast(message)
        raise NotImplementedError, "not implemented: broadcast(#{message.inspect})"
      end

      def broadcast_and_wait(message)
        raise NotImplementedError, "not implemented: broadcast_and_wait(#{message.inspect})"
      end
    end
  end
end
