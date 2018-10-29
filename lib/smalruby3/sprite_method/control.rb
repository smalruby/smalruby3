module Smalruby3
  module SpriteMethod
    # Control category methods
    module Control
      STOP_OPTION = {
        all: "all",
        this_script: "this script",
        other_scripts: "other scripts in sprite"
      }

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
    end
  end
end
