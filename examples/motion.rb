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
            },
            {
              name: "speed",
              value: "10"
            }
          ]) do
end

Sprite.new("スプライト1",
           x: -20,
           y: -30,
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
  self.when(:key_pressed, "left arrow") do
    self.x += -1 * $speed
  end

  self.when(:key_pressed, "right arrow") do
    self.x += $speed
  end

  self.when(:key_pressed, "up arrow") do
    self.y += $speed
  end

  self.when(:key_pressed, "down arrow") do
    self.y += -1 * $speed
  end

  self.when(:flag_clicked) do
    $speed = 10
  end
end
