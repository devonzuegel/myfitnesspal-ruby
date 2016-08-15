require 'binary/packet_list'
require 'support/mocks/packet_mocks/deserialized'
require 'support/mocks/packet_mocks/raw'

RSpec.describe MFP::Binary::PacketList do
  let(:packet_list) { described_class.new(PacketMocks::Raw.sync_request_default * 2) }

  describe '#initialize' do
    it 'sets raw packet to be passed in value' do
      expect(packet_list.raw).to eq(PacketMocks::Raw.sync_request_default * 2)
    end
  end

  describe '#each' do
    it 'is an iterator' do
      expect { |b| packet_list.each(&b) }.to yield_control
    end

    it 'yields Binary::Packet-subclassed objects' do
      packet_list.each do |packet|
        expect(packet.class).to eq MFP::Binary::SyncRequest
        expect(packet.to_h).to eq PacketMocks::Hash::SYNC_REQUEST_DEFAULT
      end
    end
  end

  # describe '#read_raw_packet' do
  #   it 'require the header to contain the correct magic number' do
  #     expect { Codec.new(PacketMocks::Raw::BAD_HEADER).read_raw_packet }
  #       .to raise_error TypeError
  #   end
  # end

  # describe '#read_map' do
  #   it 'extracts the values from an encoded map' do
  #     expect(Codec.new(PacketMocks::Raw::SIMPLE_MAP).read_map).to eq(2 => 'foobar')
  #   end
  # end
end
