require 'bundler/setup'
require 'rspec'
require 'json'

require 'binary/sync_request'
require 'mocks/fake_codec'
require 'mocks/packet_mocks/deserialized'

RSpec.describe MFP::Binary::SyncRequest do
  let(:sync_req) { described_class.new(username: 'uname', password: 'passw0rd') }

  let(:initial_hash) do
    PacketMocks::Hash::SYNC_REQUEST_DEFAULT.merge(packet_type: 1)
  end

  let(:updated_hash) do
    PacketMocks::Hash::SYNC_REQUEST_UPDATED.merge(packet_type: 1)
  end

  before do
    allow(SecureRandom).to receive(:hex)
      .and_return(initial_hash.fetch(:installation_uuid))
  end

  describe '#to_h' do
    it 'should serialize the starting attributes' do
      expect(sync_req.to_h).to eq initial_hash
    end
  end

  describe '#read_body_from_codec' do
    it 'should change the values after reading from the codec' do
      expect { sync_req.read_body_from_codec(FakeCodec.new) }
        .to change { sync_req.to_h }
        .from(initial_hash)
        .to(updated_hash)
    end

    it 'should correctly read the @last_sync_pointers with the codec'
  end

  describe '#packed' do
    it 'packs the request into binary format' do
      packed_request =
        "\x04\xD3\x00\x00\x007\x00\x01\x00\x01\x00\x06\x00\x00\x00\xED\x00\x02" \
        "\x00\x05uname\x00\bpassw0rd"                                           \
        "\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".b

      expect(sync_req.packed).to eq packed_request
    end
  end
end
