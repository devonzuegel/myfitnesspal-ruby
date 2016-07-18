require 'codec'
require 'binary/type'
require 'binary/packet'
require 'mocks/packet_mocks/deserialized'
require 'mocks/packet_mocks/raw'

RSpec.describe MFP::Codec do
  let(:codec) { described_class.new(PacketMocks::Raw.sync_request_default * 2) }

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
        expect(packet.class).to eq MFP::Binary::SyncRequest
        expect(packet.to_h).to eq PacketMocks::Hash::SYNC_REQUEST_DEFAULT
      end
    end
  end

  describe '#read_raw_packet' do
    it 'require the header to contain the correct magic number' do
      codec = described_class.new(PacketMocks::Raw::BAD_HEADER)
      expect { codec.read_raw_packet }.to raise_error TypeError
    end

    it 'separates the body from the header data' do
      body = "I am the body"*10
      sync_request =
        "\x04\xD3" \
        "\x00\x00\x00\x2a" \
        "\x00\x02" \
        "\x00\x01" \
        "#{body}"

      codec = described_class.new(sync_request)
      expect(codec.read_raw_packet).to eql(
        magic_number: 1235,
        length:       42,
        unknown1:     2,
        type:         1,
        body:         body.slice(0,32)
      )
    end
  end

  describe '#read_date' do
    it 'parses an iso8601 date' do
      codec = described_class.new('1993-10-07JUNK')
      expect(codec.read_date).to eql(Date.new(1993, 10, 7))
      expect(codec.remainder).to eql('JUNK')
    end
  end

  describe '#read_map' do
    it 'extracts the values from an encoded map' do
      expect(described_class.new(PacketMocks::Raw::SIMPLE_MAP).read_map).to eq(2 => 'foobar')
    end
  end
end
