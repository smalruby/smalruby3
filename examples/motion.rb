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
  self.when(:flag_clicked) do
    go_to("_random_")
#    sleep(1)
#    go_to("_mouse_")
#    sleep(1)
#    go_to([100, 100])
  end
end
