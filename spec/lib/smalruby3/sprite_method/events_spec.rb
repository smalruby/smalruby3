require "spec_helper"

describe Smalruby3::SpriteMethod::Events do
  include_context "sprite1"

  describe "#when(:flag_clicked)" do
    it "can call" do
      flag = false
      sprite1.when(:flag_clicked) do
        flag = true
      end
      sprite1.fire(:flag_clicked)
      sprite1.join_threads(true)
      expect(flag).to be_truthy
    end
  end
end
