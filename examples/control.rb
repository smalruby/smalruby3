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
           x: -41.803006548060864,
           y: -13.034491307060054,
           direction: 120,
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
    loop do
      if Keyboard.pressed?("space")
        until Keyboard.pressed?("right arrow")
          turn_right(15)
          wait
        end
      else
        1.times do
          wait until Keyboard.pressed?("left arrow")
          create_clone("_myself_")
          turn_left(15)
          wait
        end
      end
      wait
    end
  end

  self.when(:start_as_a_clone) do
    loop do
      if Keyboard.pressed?("up arrow")
        delete_this_clone
      end
      if Keyboard.pressed?("down arrow")
        sleep(1)
        stop("all")
      end
      wait
    end
  end
end
