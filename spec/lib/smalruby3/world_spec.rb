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

  describe "#add_sprite, #sprite, #delete_sprite" do
    it "add sprite, reference sprite, delete sprite" do
      world = World.instance
      sprite = double("Sprite", name: "Sprite1")

      world.add_sprite(sprite)

      expect(world.sprite("Sprite1")).to eq(sprite)

      world.delete_sprite(sprite)

      expect(world.sprite("Sprite1")).to be_nil
    end

    it "error same sprite if add sprite twice" do
      world = World.instance
      sprite = double("Sprite", name: "Sprite1")

      world.add_sprite(sprite)

      expect {
        world.add_sprite(sprite)
      }.to raise_error(ExistSprite)
    end
  end

  describe "#targets" do
    it "return stage and sprites array" do
      world = World.instance
      stage = double("Stage", name: "Stage")
      sprite = double("Sprite", name: "Sprite1")

      world.stage = stage
      world.add_sprite(sprite)

      expect(world.targets).to eq([stage, sprite])
    end
  end

  describe "#reset" do
    it "clear stage and sprites" do
      world = World.instance

      world.reset

      expect(world.stage).to be_nil
      expect(world.targets).to be_empty
    end
  end
end
