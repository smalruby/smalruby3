module Smalruby3
  module SpriteMethod
    # Control category methods
    module Control
      STOP_OPTION = {
        all: "all",
        this_script: "this script",
        other_scripts: "other scripts in sprite"
      }

      def repeat(num, &_block)
        num.times do
          yield
          wait
        end
      end

      def forever(&_block)
        loop do
          yield
          Smalruby3.wait
        end
      end

      def stop(option)
        case option
        when STOP_OPTION[:all]
          raise StopAll
        when STOP_OPTION[:this_script]
          raise StopThisScript
        when STOP_OPTION[:other_scripts]
          raise StopOtherScripts
        else
          raise ArgumentError.new("invalid option: #{option}")
        end
      end

      def wait
        Smalruby3.wait
      end

      def create_clone(option)
        raise NotImplementedError, "not implemented: create_clone(#{option.inspect})"
      end

      def delete_this_clone
        raise NotImplementedError, "not implemented: delete_this_clone"
      end
    end
  end
end
