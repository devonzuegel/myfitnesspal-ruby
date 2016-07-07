require 'bundler/setup'
require 'rspec'

require 'binary/sync_response'
# require 'mocks/fake_codec'

RSpec.describe Binary::SyncResponse do
  let(:sync_res) { Binary::SyncResponse.new }

  # describe '#to_json' do
  #   it 'should serialize the starting attributes' do
  #     expect(JSON.parse(sync_req.to_json)).to eq DEFAULT_VALUES
  #   end
  # end

  describe '#read_body_from_codec' do
    it '...' do
      # expect { sync_req.read_body_from_codec(FakeCodec.new) }
      #   .to change { JSON.parse(sync_req.to_json) }
      #   .from(DEFAULT_VALUES)
      #   .to(UPDATED_VALUES)
    end
  end

  # it { should respond_to(:write_body_to_codec) }

  # describe '#write_packet_to_codec' do
  #   it 'should be an abstract method' do
  #     expect { sync_req.write_packet_to_codec(FakeCodec.new) }
  #       .to change { JSON.parse(sync_req.to_json) }
  #       .from(DEFAULT_VALUES)
  #       .to(DEFAULT_VALUES.merge(
  #         '@packet_start'  => 1,
  #         '@packet_length' => 2
  #       ))
  #   end
  # end
end