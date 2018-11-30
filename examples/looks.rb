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
           size: 120.00000000000001,
           costumes: [
             {
               asset_id: "01ae57fd339529445cb890978ef8a054",
               name: "コスチューム1",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 47,
               rotation_center_y: 55
             },
             {
               asset_id: "5a4148d7684fc95f38c58a1672062c9e",
               name: "Bear-a",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 100,
               rotation_center_y: 90
             },
             {
               asset_id: "d6517131718621a7aae8fc4f27de1ded",
               name: "Bear-b",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 80,
               rotation_center_y: 140
             }
           ]) do
  self.when(:flag_clicked) do
    say(message: "こんにちは!", second: 2)
    say(message: "こんにちは!")
    think(message: "うーん...", second: 2)
    self.size += 10
    switch_costume("Bear-a")
    next_costume
  end
end
