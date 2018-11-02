require "spec_helper"

describe Smalruby3::World do
  describe ".instance" do
    it {
      expect(World.instance).to be_kind_of(World)
    }

    it "return same instance" do
      expect(World.instance).to eq(World.instance)
    end
  end

  describe "#add_target, #sprite, #delete_target" do
    it "add sprite, reference sprite, delete sprite" do
      world = World.instance
      sprite = double("Sprite", name: "Sprite1", "stage?": false)

      world.add_target(sprite)

      expect(world.sprite("Sprite1")).to eq(sprite)

      world.delete_target(sprite)

      expect(world.sprite("Sprite1")).to be_nil
    end

    it "error existing sprite if add sprite twice" do
      world = World.instance
      sprite = double("Sprite", name: "Sprite1", "stage?": false)

      world.add_target(sprite)

      expect {
        world.add_target(sprite)
      }.to raise_error(ExistSprite)
    end

    it "add stage, reference stage, delete target" do
      world = World.instance
      stage = double("Stage", name: "Stage", "stage?": true)

      world.add_target(stage)

      expect(world.stage).to eq(stage)

      world.delete_target(stage)

      expect(world.stage).to be_nil
    end

    it "error existing stage if add stage twice" do
      world = World.instance
      stage = double("Stage", name: "Stage", "stage?": true)

      world.add_target(stage)

      expect {
        world.add_target(stage)
      }.to raise_error(ExistStage)
    end
  end

  describe "#targets" do
    it "return stage and sprites array" do
      world = World.instance
      stage = double("Stage", name: "Stage", "stage?": true)
      sprite = double("Sprite", name: "Sprite1", "stage?": false)

      world.add_target(stage)
      world.add_target(sprite)

      expect(world.targets).to eq([stage, sprite])
    end
  end

  describe "#reset" do
    it "clear stage and sprites" do
      world = World.instance

      world.reset

      expect(world.stage).to be_nil
      expect(world.sprites).to be_empty
      expect(world.targets).to be_empty
    end
  end
end
