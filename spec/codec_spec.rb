require 'codec'
require 'binary/type'
require 'binary/packet'
require 'mocks/packet_mocks/deserialized'
require 'mocks/packet_mocks/raw'

RSpec.describe Codec do
  let(:codec) { Codec.new(PacketMocks::Raw.sync_request_default * 2) }

  describe '#initialize' do
    it 'should set raw packet to be passed in value' do
      expect(codec.original_str).to eq PacketMocks::Raw.sync_request_default * 2
    end
  end

  describe '#raw_packets' do
    let(:expected_body) do
      PacketMocks::Raw.sync_request_default.slice(0, Binary::Packet::HEADER_SIZE)
    end

    it 'splits the stream of packets into individual raw packets based on the header' do
      expect(codec.raw_packets.length).to eq 2
      codec.raw_packets.each do |raw_packet|
        expect(raw_packet).to eq(
          body:         expected_body,
          magic_number: Binary::Packet::MAGIC,
          type:         1,
          unknown1:     2
        )
      end
    end
  end

  describe '#each_packet' do
    it 'is an iterator' do
      expect { |b| codec.each_packet(&b) }.to yield_control
    end

    it 'yields Binary::Packet-subclassed objects' do
      codec.each_packet do |packet|
        expect(packet.class).to eq Binary::SyncRequest
        expect(packet.to_h).to eq PacketMocks::Hash::SYNC_REQUEST_DEFAULT
      end
    end
  end

  describe '#read_raw_packet' do
    it 'require the header to contain the correct magic number' do
      expect { Codec.new(PacketMocks::Raw::BAD_HEADER).read_raw_packet }
        .to raise_error TypeError
    end
  end

  describe '#read_map' do
    it 'extracts the values from an encoded map' do
      expect(Codec.new(PacketMocks::Raw::SIMPLE_MAP).read_map).to eq(2 => 'foobar')
    end
  end
end
