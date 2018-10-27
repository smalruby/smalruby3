require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "smalruby3"
Smalruby3.instance_variable_set("@started", true)

Dir.glob(File.expand_path("../support/**/*.rb", __FILE__)).each do |path|
  require path
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = "random"

  config.before do
    World.instance.reset
  end
end

RSpec.shared_context "sprite1" do
  let(:sprite1) {
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
      ]
    )
  }
end
