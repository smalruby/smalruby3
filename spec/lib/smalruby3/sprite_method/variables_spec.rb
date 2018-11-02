require "spec_helper"

describe Smalruby3::SpriteMethod::Variables do
  include_context "sprite1"

  describe "#show_variable" do
    it "can not call" do
      expect {
        sprite1.show_variable("@local_variables")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#hide_variable" do
    it "can not call" do
      expect {
        sprite1.hide_variable("@local_variables")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#show_list" do
    it "can not call" do
      expect {
        sprite1.show_list("@local_list")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#hide_list" do
    it "can not call" do
      expect {
        sprite1.hide_list("@local_variables")
      }.to raise_error(NotImplementedError)
    end
  end
end
