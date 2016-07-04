require 'bundler/setup'
require 'rspec'

require 'binary/sync_request'
require 'mocks/fake_codec'

RSpec.describe Binary::SyncRequest do
  before do
    allow(SecureRandom)
      .to receive(:uuid)
      .and_return(DEFAULT_VALUES['@installation_uuid'])
  end

  let(:sync_req) { Binary::SyncRequest.new }

  describe '#to_json' do
    it 'should serialize the starting attributes' do
      expect(JSON.parse(sync_req.to_json)).to eq DEFAULT_VALUES
    end
  end

  describe '#read_body_from_codec' do
    it 'should be an abstract method' do
      expect { sync_req.read_body_from_codec(FakeCodec.new) }
        .to change { JSON.parse(sync_req.to_json) }
        .from(DEFAULT_VALUES)
        .to(UPDATED_VALUES)
    end
  end

  it { should respond_to(:write_body_to_codec) }

  describe '#write_packet_to_codec' do
    it 'should be an abstract method' do
      expect { sync_req.write_packet_to_codec(FakeCodec.new) }
        .to change { JSON.parse(sync_req.to_json) }
        .from(DEFAULT_VALUES)
        .to(DEFAULT_VALUES.merge(
          '@packet_start'  => 1,
          '@packet_length' => 2
        ))
    end
  end
end

DEFAULT_VALUES = {
  '@packet_start'       => nil,
  '@packet_length'      => nil,
  '@api_version'        => 6,
  '@svn_revision'       => 237,
  '@unknown1'           => 2,
  '@username'           => '',
  '@password'           => '',
  '@flags'              => 5,
  '@installation_uuid'  => 'sample_uuid',
  '@last_sync_pointers' => {}
}

UPDATED_VALUES = {
  '@api_version'        => 1,
  '@flags'              => 1,
  '@installation_uuid'  => 'this_is_a_uuid',
  '@last_sync_pointers' => 'codec_map',
  '@packet_length'      => nil,
  '@packet_start'       => nil,
  '@password'           => 'hello_world',
  '@svn_revision'       => 1,
  '@unknown1'           => 1,
  '@username'           => 'hello_world'
}