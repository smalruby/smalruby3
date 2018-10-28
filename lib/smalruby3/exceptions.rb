module Smalruby3
  class Exception < StandardError
  end

  class ExistStage < Exception
    attr_accessor :stage

    def initialize(stage)
      @stage = stage
      super("already exist stage: #{stage.name}")
    end
  end

  class ExistSprite < Exception
    attr_accessor :sprite

    def initialize(sprite)
      @sprite = sprite
      super("already exist sprite: #{sprite.name}")
    end
  end
end
