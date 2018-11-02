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

    it "define instance variables from variables and lists arguments" do
      s = Sprite.new(
        "Sprite1",
        variables: [
          {
            name: "local_variable",
            value: "abc"
          },
          {
            name: "local_variable2",
          }
        ],
        lists: [
          {
            name: "local_list",
            value: ["a", "b", "c"]
          },
          {
            name: "local_list2"
          }
        ]
      ) do
      end
      expect(s.instance_variable_get("@local_variable")).to eq("abc")
      expect(s.instance_variable_get("@local_variable2")).to eq(0)
      expect(s.instance_variable_get("@local_list")).to eq(["a", "b", "c"])
      expect(s.instance_variable_get("@local_list2")).to eq([])
    end
  end
end
