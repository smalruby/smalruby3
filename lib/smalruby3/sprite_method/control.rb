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
          wait
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
        if option == "_myself_"
          # 自分自身のコピーをつくる
          cloned = clone
          # 自分自身がつくったものや、お願いしたこともコピーする
          cloned.instance_variable_set("@dxruby_sprite", DXRuby::Sprite.new(0, 0))
          cloned.send(:sync_costumes)
        end
        cloned.name += rand(1000000).to_s
        World.instance.add_target(cloned)
      end

      def delete_this_clone
        raise NotImplementedError, "not implemented: delete_this_clone"
      end
    end
  end
end
