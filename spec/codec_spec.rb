require 'bundler/setup'
require 'rspec'

require 'codec'
require 'binary/type'
require 'binary/packet'

RSpec.describe Codec do
  let(:original_str) do
    [
      [Binary::Packet::MAGIC].pack('s>'),
      [500].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>')
    ].join
  end

  let(:bad_magic) do
    [
      [1].pack('s>'),
      [500].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>')
    ].join
  end

  let(:codec) { Codec.new(original_str) }

  describe '#initialize' do
    it 'should set original_str to be passed in value' do
      expect(codec.original_str).to eq original_str
    end
  end

  describe '#read_packets' do
    it 'is an iterator' do
      expect { |b| codec.read_packets(&b) }.to yield_control
    end

    it 'yields Binary::Packet-subclassed objects'
  end

  describe '#read_packet' do
    it 'require the header to contain the correct magic number' do
      expect { Codec.new(bad_magic).read_packet }.to raise_error TypeError
    end
  end

  describe '#supported_types' do
    it 'should support the expected types' do
      expect(codec.supported_types).to eq(
        Binary::Type::SYNC_REQUEST => Binary::SyncRequest
      )
    end

    it 'supports all types'
  end
end
