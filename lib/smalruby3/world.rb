require "singleton"
require_relative "exceptions"

module Smalruby3
  # 環境を表現するクラス
  class World
    include Singleton

    attr_accessor :sprites
    attr_accessor :stage

    def initialize
      reset
    end

    def add_sprite(sprite)
      if @name_to_sprite.key?(sprite.name)
        raise ExistSprite.new(sprite)
      end
      @sprites << sprite
      @name_to_sprite[sprite.name] = sprite
      sprite
    end

    def delete_sprite(sprite)
      @sprites.delete(sprite)
      @name_to_sprite.delete(sprite.name)
      sprite
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

    private

    def clear_sprites
      @stage = nil
      @sprites = []
      @name_to_sprite = {}
    end
  end
end
