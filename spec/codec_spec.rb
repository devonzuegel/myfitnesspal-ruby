require 'bundler/setup'
require 'rspec'

require 'codec'
require 'binary/type'
require 'binary/packet'
require 'mocks/packet_mocks'

RSpec.describe Codec do
  let(:codec) { Codec.new(PacketMocks::Raw::SYNC_REQUEST) }

  describe '#initialize' do
    it 'should set raw packet to be passed in value' do
      expect(codec.original_str).to eq PacketMocks::Raw::SYNC_REQUEST
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
      expect { Codec.new(PacketMocks::Raw::BAD_MAGIC).read_packet }.to raise_error TypeError
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
