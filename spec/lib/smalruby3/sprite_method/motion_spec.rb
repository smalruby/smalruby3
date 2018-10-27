require 'spec_helper'

describe Smalruby3::SpriteMethod::Motion do
  before do
    Sprite.new("Sprite1",
      costumes: [
        {
          asset_id: "01ae57fd339529445cb890978ef8a054",
          name: "Costume1",
          bitmap_resolution: 1,
          md5: "01ae57fd339529445cb890978ef8a054.svg",
          data_format: "svg",
          rotation_center_x: 47,
          rotation_center_y: 55
        }
      ]
    )
  end

  describe "#move" do
    it "can call" do
      sprite("Sprite1").move(10)
    end
  end
end
