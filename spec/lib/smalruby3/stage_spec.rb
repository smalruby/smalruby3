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
            bitmap_resolution: 2,
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

    it "define global variables from variables and lists arguments" do
      s = Stage.new(
        "Stage",
        variables: [
          {
            name: "global_variable",
            value: "abc"
          },
          {
            name: "global_variable2",
          }
        ],
        lists: [
          {
            name: "global_list",
            value: ["a", "b", "c"]
          },
          {
            name: "global_list2"
          }
        ]
      ) do
      end
      expect($global_variable).to eq("abc")
      expect($global_variable2).to eq(0)
      expect($global_list).to eq(["a", "b", "c"])
      expect($global_list2).to eq([])
    end
  end
end
