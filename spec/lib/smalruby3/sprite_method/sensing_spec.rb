require "spec_helper"

describe Smalruby3::SpriteMethod::Sensing do
  include_context "sprite1"

  describe "#touching?" do
    it "can call" do
      expect(sprite1.touching?("_edge_")).to eq(false)
      sprite1.x = 240
      sprite1.y = 0
      expect(sprite1.touching?("_edge_")).to eq(true)
    end
  end
end
