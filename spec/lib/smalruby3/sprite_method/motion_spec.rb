require 'spec_helper'

describe Smalruby3::SpriteMethod::Motion do
  include_context "sprite1"

  describe "#move" do
    it "can call" do
      expect(sprite1.move(10)).to eq([10, 0])
      expect(sprite1.x).to eq(10)
      expect(sprite1.y).to eq(0)
    end
  end

  describe "#turn_right" do
    it "can call" do
      expect(sprite1.turn_right(180)).to eq(-90)
      expect(sprite1.direction).to eq(-90)
    end
  end

  describe "#direction=, #direction" do
    it "can call" do
      expect(sprite1.direction).to eq(90)

      {
        0 => 0,
        179 => 179,
        180 => 180,
        181 => -179,
        359 => -1,
        360 => 0,
        361 => 1,
      }.each do |degrees, expected|
        sprite1.direction = degrees
        expect(sprite1.direction).to eq(expected)
      end
    end
  end
end
