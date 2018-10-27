module Smalruby3
  module SpriteMethod
    # Sound category methods
    module Sound
      def play(option = {})
        defaults = {
          name: 'piano_do.wav'
        }
        opt = process_optional_arguments(option, defaults)

        sound = new_sound(opt[:name])
        sound.set_volume(calc_volume)
        sound.play
      end

      def stop_all_sounds
        @@sound_cache.synchronize do
          @@sound_cache.each_value do |sound|
            sound.stop
          end
        end
      end
    end
  end
end
