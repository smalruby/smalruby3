module Smalruby3
  class ExistStage < RuntimeError
    attr_accessor :stage

    def initialize(stage)
      @stage = stage
      super("already exist stage: #{stage.name}")
    end
  end

  class ExistSprite < RuntimeError
    attr_accessor :sprite

    def initialize(sprite)
      @sprite = sprite
      super("already exist sprite: #{sprite.name}")
    end
  end
end
