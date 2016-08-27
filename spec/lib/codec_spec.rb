require 'local_file'
require 'codec'
require 'binary/type'
require 'binary/packet'
require 'support/mocks/packet_mocks/deserialized'
require 'support/mocks/packet_mocks/raw'

describe MFP::Codec do
  let(:codec) { described_class.new(PacketMocks::Raw.sync_request_default * 2) }

  describe '#initialize' do
    it 'sets raw packet to be passed in value' do
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
      body = 'I am the body' * 10
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
        body:         body.slice(0, 32)
      )
    end
  end

  describe 'integration test' do
    let(:response_fixture) { LocalFile.read(fixture('response.bin')) }

    it 'creates the expected count of each packet type' do
      packet_type_counts = Hash.new(0)
      described_class.new(response_fixture).each_packet do |p|
        type = MFP::Binary::Type.supported_types.fetch(p.packet_type)
        packet_type_counts[type] += 1
      end

      expect(packet_type_counts).to eq(
        MFP::Binary::Exercise           => 1,
        MFP::Binary::Food               => 54,
        MFP::Binary::FoodEntry          => 848,
        MFP::Binary::MealIngredients    => 10,
        MFP::Binary::MeasurementTypes   => 1,
        MFP::Binary::SyncResponse       => 1,
        MFP::Binary::UserPropertyUpdate => 1
      )
    end
  end
end
