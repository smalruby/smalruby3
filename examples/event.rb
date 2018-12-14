require "smalruby3"

Stage.new("Stage",
          costumes: [
            {
              asset_id: "cd21514d0531fdffb22204e0ec5ed84a",
              name: "背景1",
              bitmap_resolution: 1,
              data_format: "svg",
              rotation_center_x: 240,
              rotation_center_y: 180
            }
          ],
          variables: [
            {
              name: "作った変数"
            }
          ]) do
end

Sprite.new("スプライト1",
           x: 2.4778961420147922,
           y: 58.644506254374804,
           direction: -108.46304096718444,
           costumes: [
             {
               asset_id: "01ae57fd339529445cb890978ef8a054",
               name: "コスチューム1",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 47,
               rotation_center_y: 55
             }
           ]) do
  self.when(:flag_clicked) do
    broadcast("こんにちは")
    broadcast_and_wait("こんにちは")
    loop do
      move(10)
      bounce_if_on_edge
      wait
    end
  end

  self.when(:greater_than, "LOUDNESS", 10) do
    move(10)
  end

  self.when(:click) do
    go_to("_mouse_")
  end

  self.when(:backdrop_switches, "背景1") do
    turn_right(15)
  end

  self.when(:greater_than, "LOUDNESS", 10) do
    move(10)
  end

  self.when(:receive, "こんにちは") do
    self.x += 10
  end
end
