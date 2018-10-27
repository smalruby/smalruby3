require "spec_helper"

describe Smalruby3::World do
  describe ".instance" do
    it {
      expect(described_class.instance).to be_kind_of(described_class)
    }

    it "return same instance" do
      expect(described_class.instance).to eq(described_class.instance)
    end
  end
end
