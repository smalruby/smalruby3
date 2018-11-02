require "singleton"
require_relative "exceptions"
require_relative "smalruby_to_dxruby"

module Smalruby3
  class World
    include Singleton

    attr_accessor :stage
    attr_accessor :sprites
    attr_reader :s2dx

    def initialize
      reset
      @s2dx = SmalrubyToDXRuby.new
    end

    def add_target(stage_or_sprite)
      if stage_or_sprite.stage?
        stage = stage_or_sprite
        if @stage
          raise ExistStage.new(stage)
        end
        @stage = stage
      else
        sprite = stage_or_sprite
        if @name_to_sprite.key?(sprite.name)
          raise ExistSprite.new(sprite)
        end
        @sprites << sprite
        @name_to_sprite[sprite.name] = sprite
      end
      stage_or_sprite
    end

    def delete_target(stage_or_sprite)
      if stage_or_sprite.stage?
        @stage = nil
      else
        sprite = stage_or_sprite
        @sprites.delete(sprite)
        @name_to_sprite.delete(sprite.name)
      end
      stage_or_sprite
    end

    def sprite(name)
      @name_to_sprite[name]
    end

    def targets
      [@stage, *@sprites].compact
    end

    def reset
      clear_sprites
    end

    def asset_path(asset_id, data_format)
      if data_format == "svg"
        data_format = "png"
      end
      md5 = "#{asset_id}.#{data_format}"

      program_path = Pathname($PROGRAM_NAME).expand_path(Dir.pwd)
      paths = [
        Pathname("../#{md5}").expand_path(program_path),
        Pathname("../__assets__/#{md5}").expand_path(program_path),
        Pathname("../../../assets/#{md5}").expand_path(__FILE__),
      ]
      paths.find(&:file?).to_s
    end

    private

    def clear_sprites
      @stage = nil
      @sprites = []
      @name_to_sprite = {}
    end
  end
end
