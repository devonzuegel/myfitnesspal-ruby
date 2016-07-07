require 'codec'
require 'binary/type'
require 'binary/packet'
require 'mocks/packet_mocks/json'
require 'mocks/packet_mocks/raw'

RSpec.describe Codec do
  let(:codec) { Codec.new(PacketMocks::Raw.sync_request_default) }

  describe '#initialize' do
    it 'should set raw packet to be passed in value' do
      expect(codec.original_str).to eq PacketMocks::Raw.sync_request_default
    end
  end

  describe '#read_packets' do
    it 'is an iterator' do
      expect { |b| codec.read_packets(&b) }.to yield_control
    end

    it 'yields Binary::Packet-subclassed objects' do
      codec.read_packets do |packet|
        expect(packet.class).to eq Binary::SyncRequest
        expect(packet.to_json).to eq PacketMocks::Json::SYNC_REQUEST_DEFAULT
      end
    end
  end

  describe '#read_packet' do
    it 'require the header to contain the correct magic number' do
      expect { Codec.new(PacketMocks::Raw::BAD_HEADER).read_packet }.to raise_error TypeError
    end
  end

  describe '#read_map' do
    it 'extracts the values from an encoded map' do
      expect(Codec.new(PacketMocks::Raw::SIMPLE_MAP).read_map).to eq(2 => 'foobar')
    end
  end
end
