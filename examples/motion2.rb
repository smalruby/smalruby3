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
           x: -124.12359052154574,
           y: 130.17724550778007,
           direction: -54.58450204512181,
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
    point_towards("_mouse_")
  end
end
