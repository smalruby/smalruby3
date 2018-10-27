require 'spec_helper'

describe Smalruby3::Sprite do
  describe '#switch_costume' do
    let(:sprite) {
      described_class.new(costume: %w(car1.png char2:car2.png car3.png))
    }

    subject { sprite.costume_index }

    name_to_index = {
      "costume1" => 0,
      "char2" => 1,
      "costume3" => 2,
    }

    name_to_index.each do |name, index|
      context "name is #{name}" do
        _name, _index = name, index

        let(:name) { name }
        let(:index) { index }

        before do
          sprite.switch_costume(name)
        end

        it { expect(subject).to eq(index) }
      end
    end
  end
end
