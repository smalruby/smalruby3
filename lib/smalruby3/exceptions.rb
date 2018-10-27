module Smalruby3
  class Exception < StandardError
  end

  class ExistSprite < Exception
    attr_accessor :sprite

    def initialize(sprite)
      @sprite = sprite
      super("already exist sprite: #{sprite.name}")
    end
  end
end
