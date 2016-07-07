require 'bundler/setup'
require 'rspec'
require 'json'

require 'binary/sync_request'
require 'mocks/fake_codec'
require 'mocks/packet_mocks/json'

RSpec.describe Binary::SyncRequest do
  let(:sync_req) { Binary::SyncRequest.new(30) }

  let(:initial_json) do
    PacketMocks::Json::SYNC_REQUEST_DEFAULT.merge(
      packet_type:   1,
      packet_length: 30
    )
  end

  let(:updated_json) do
    PacketMocks::Json::SYNC_REQUEST_UPDATED.merge(
      packet_type:   1,
      packet_length: 30
    )
  end

  before do
    allow(SecureRandom)
      .to receive(:hex)
      .and_return(initial_json.fetch(:installation_uuid))
  end

  describe '#to_json' do
    it 'should serialize the starting attributes' do
      expect(sync_req.to_json).to eq initial_json
    end
  end

  describe '#read_body_from_codec' do
    it 'should change the values after reading from the codec' do
      expect { sync_req.read_body_from_codec(FakeCodec.new) }
        .to change { sync_req.to_json }
        .from(initial_json)
        .to(updated_json)
    end

    it 'should correctly read the @last_sync_pointers with the codec'
  end

  describe '#write_body_to_codec' do
    it do
      expect(sync_req).to respond_to(:write_body_to_codec)
    end
  end

  describe '#write_packet_to_codec' do
    it 'should be an abstract method'
    # do
    #   expect { sync_req.write_packet_to_codec(FakeCodec.new) }
    #     .to change { sync_req.to_json }
    #     .from(initial_json)
    #     .to(updated_json)
    # end
  end
end