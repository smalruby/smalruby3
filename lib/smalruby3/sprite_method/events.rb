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
    end
  end
end
