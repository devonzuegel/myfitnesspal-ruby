require 'bundler/setup'
require 'rspec'

require 'codec'

RSpec.describe Codec do
  let(:original_str) { 'blah' }
  let(:codec)        { Codec.new(original_str) }

  describe '#initialize' do
    it 'should set original_str to be passed in value' do
      expect(codec.original_str).to eq original_str
    end
  end

  describe '#read_packets' do
    it 'should return an iterator yielding BinaryPacket-subclassed objects'

    it 'should be an iterator' do
      expect { |b| codec.read_packets(&b) }.to yield_control
    end
  end
end
