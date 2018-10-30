require "spec_helper"

describe Smalruby3::Sprite do
  describe ".new" do
    it "receiver is the created sprite in block" do
      self_in_block = nil
      s = Sprite.new(
        "Sprite1",
        costumes: [
          {
            asset_id: "01ae57fd339529445cb890978ef8a054",
            name: "Costume1",
            bitmap_resolution: 1,
            data_format: "svg",
            rotation_center_x: 47,
            rotation_center_y: 55
          }
        ]
      ) do
        self_in_block = self
      end
      expect(s).to eq(self_in_block)
    end
  end
end
