require "spec_helper"

describe Smalruby3::SpriteMethod::Control do
  include_context "sprite1"

  describe "#forever" do
    it "can call" do
      allow(Smalruby3).to receive(:wait)

      count = 0
      begin
        sprite1.forever do
          count += 1
          if count == 2
            sprite1.stop(Smalruby3::SpriteMethod::Control::STOP_OPTION[:this_script])
          end
        end
      rescue StopThisScript
      end
      expect(count).to eq(2)
    end
  end

  describe "#stop" do
    it "raise Stop*" do
      expect {
        sprite1.stop(Smalruby3::SpriteMethod::Control::STOP_OPTION[:all])
      }.to raise_error(StopAll)

      expect {
        sprite1.stop(Smalruby3::SpriteMethod::Control::STOP_OPTION[:this_script])
      }.to raise_error(StopThisScript)

      expect {
        sprite1.stop(Smalruby3::SpriteMethod::Control::STOP_OPTION[:other_scripts])
      }.to raise_error(StopOtherScripts)
    end

    it "raise ArgumentError if invalid option" do
      option = "unknown"
      expect {
        sprite1.stop(option)
      }.to raise_error(ArgumentError, "invalid option: #{option}")
    end
  end

  describe "#wait" do
    it "can call" do
      allow(Smalruby3).to receive(:wait)

      sprite1.wait

      expect(Smalruby3).to have_received(:wait)
    end
  end
end
