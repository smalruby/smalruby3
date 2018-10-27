require "smalruby3"

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
  ]) do
  self.when(:flag_clicked) do
    forever do
      move(10)
      if touching?("_edge_")
        turn_right(180)
      end
    end
  end
end
