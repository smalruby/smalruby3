module Smalruby3
  class EventHandler
    attr_accessor :object
    attr_accessor :options
    attr_accessor :block

    def initialize(object, options, &block)
      @object = object
      @options = options
      @block = block
      @running = false
    end

    def call(*args)
      if @running
        return nil
      end

      return Thread.start(@object, @block) { |object, block|
        begin
          @running = true
          object.instance_exec(*args, &block)
        ensure
          @running = false
        end
      }
    end
  end
end
