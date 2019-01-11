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
           x: -95.95599737377401,
           y: -18.09090187827208,
           direction: 84.45456849816662,
           costumes: [
             {
               asset_id: "01ae57fd339529445cb890978ef8a054",
               name: "コスチューム1",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 46,
               rotation_center_y: 53
             }
           ]) do
  point_towards("Apple")
  move(10)
end

Sprite.new("Apple",
           x: 131.5186721991701,
           y: 3.994475138121554,
           costumes: [
             {
               asset_id: "3826a4091a33e4d26f87a2fac7cf796b",
               name: "apple",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 31,
               rotation_center_y: 31
             }
           ]) do
end
