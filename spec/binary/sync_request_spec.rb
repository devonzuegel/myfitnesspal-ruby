require 'bundler/setup'
require 'rspec'
require 'json'

require 'binary/sync_request'
require 'mocks/fake_codec'
require 'mocks/packet_mocks'

RSpec.describe Binary::SyncRequest do
  before do
    allow(SecureRandom)
      .to receive(:uuid)
      .and_return(PacketMocks::Json::SYNC_REQUEST.fetch(:installation_uuid))
  end

  let(:sync_req) { Binary::SyncRequest.new(0, 30) }

  describe '#to_json' do
    it 'should serialize the starting attributes' do
      expect(sync_req.to_json).to eq PacketMocks::Json::SYNC_REQUEST
    end
  end

  describe '#read_body_from_codec' do
    it 'should change the values after reading from the codec' do
      expect { sync_req.read_body_from_codec(FakeCodec.new) }
        .to change { sync_req.to_json }
        .from(PacketMocks::Json::SYNC_REQUEST)
        .to(UPDATED_VALUES)
    end
  end

  describe '#write_body_to_codec' do
    it do
      expect(sync_req).to respond_to(:write_body_to_codec)
    end
  end

  describe '#write_packet_to_codec' do
    it 'should be an abstract method' do
      expect { sync_req.write_packet_to_codec(FakeCodec.new) }
        .to change { sync_req.to_json }
        .from(PacketMocks::Json::SYNC_REQUEST)
        .to(PacketMocks::Json::SYNC_REQUEST.merge(
          packet_start:  1,
          packet_length: 2
        ))
    end
  end
end

UPDATED_VALUES = {
  packet_type:        1,
  packet_start:       0,
  packet_length:      30,
  api_version:        1,
  flags:              1,
  installation_uuid:  'this_is_a_uuid',
  last_sync_pointers: 'codec_map',
  password:           'password',
  svn_revision:       1,
  unknown1:           1,
  username:           'username'
}