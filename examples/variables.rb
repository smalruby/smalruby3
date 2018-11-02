require "smalruby3"

Stage.new("Stage",
          costumes: [
            {
              asset_id: "9838d02002d05f88dc54d96494fbc202",
              name: "Xy-grid",
              bitmap_resolution: 2,
              data_format: "png",
              rotation_center_x: 480,
              rotation_center_y: 360
            }
          ],
          variables: [
            {
              name: "global_variable",
              value: 0
            }
          ],
          lists: [
            {
              name: "global_list"
            }
          ]) do
end

Sprite.new("Variables",
           x: 77,
           y: -42,
           costumes: [
             {
               asset_id: "01ae57fd339529445cb890978ef8a054",
               name: "Costume1",
               bitmap_resolution: 1,
               data_format: "svg",
               rotation_center_x: 47,
               rotation_center_y: 55
             }
           ],
           variables: [
             {
               name: "local_variable",
               value: 0
             }
           ],
           lists: [
             {
               name: "local_list"
             }
           ]) do
  $global_variable = 0
  $global_variable += 1
  show_variable("$global_variable")
  hide_variable("$global_variable")

  $global_list.push("thing")
  $global_list.delete_at(0)
  $global_list.clear
  $global_list.insert(0, "1")
  $global_list[0] = 1

  $global_list[0]

  $global_list.index("thing")

  $global_list.length

  $global_list.include?("thing")

  show_list("$global_list")
  hide_list("$global_list")

  @local_variable = 0
  @local_variable += 1
  show_variable("@local_variable")
  hide_variable("@local_variable")

  @local_list.push("thing")
  @local_list.delete_at(0)
  @local_list.clear
  @local_list.insert(0, 1)
  @local_list[0] = 1

  @local_list[0]

  @local_list.index("thing")

  @local_list.length

  @local_list.include?("thing")

  show_list("@local_list")
  hide_list("@local_list")
end
