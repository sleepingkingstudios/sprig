require 'spec_helper'

RSpec.describe Sprig do
  describe '#adapter' do
    let(:supported_adapters) do
      %i(active_record mongoid)
    end

    it { expect(described_class).to respond_to(:adapter).with(0).arguments }

    it { expect(supported_adapters).to include described_class.adapter }
  end

  describe '#adapter=' do
    let(:value) { :mongo_mapper }

    it { expect(described_class).to respond_to(:adapter=).with(1).argument }

    it 'changes the value' do
      previous_value = described_class.adapter

      expect { described_class.adapter = value }.to change(described_class, :adapter).to(value)

      described_class.adapter = previous_value
    end
  end
end
