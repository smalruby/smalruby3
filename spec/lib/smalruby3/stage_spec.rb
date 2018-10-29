require "spec_helper"

describe Smalruby3::Stage do
  describe ".new" do
    it "receiver is the created stage in block" do
      self_in_block = nil
      s = Stage.new(
        "Stage",
        costumes: [
          {
            asset_id: "9838d02002d05f88dc54d96494fbc202",
            name: "Xy-grid",
            data_format: "png",
            rotation_center_x: 480,
            rotation_center_y: 360
          }
        ]
      ) do
        self_in_block = self
      end
      expect(s).to eq(self_in_block)
    end
  end
end
