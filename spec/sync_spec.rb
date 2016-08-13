require 'sync'

RSpec.describe MFP::Sync do
  let(:ptrs) do
    {
      'deleted_item'            => '2369971689',
      'deleted_most_used_foods' => '0',
      'diary_note'              => '2016-08-13 01:37:09 UTC',
      'exercise'                => '1018692',
      'exercise_entry'          => '2170999557',
      'food'                    => '318556366',
      'food_entry'              => '5655611135',
      'measurement'             => '2016-08-13 01:10:27 UTC',
      'user_property'           => '2016-07-03 22:20:44 UTC',
      'user_status'             => '',
      'water_entry'             => '2014-12-25 01:20:59 UTC'
    }
  end

  let(:credentials)  { [ENV['MFP_USERNAME'], ENV['MFP_PASSWORD']] }
  let(:sync)         { described_class.new(*credentials) }
  let(:partial_sync) { described_class.new(*credentials, ptrs) }

  before do
    fail Exception, 'MFP_USERNAME environment variable is nil' if ENV['MFP_USERNAME'].nil?
    fail Exception, 'MFP_PASSWORD environment variable is nil' if ENV['MFP_PASSWORD'].nil?
  end

  describe '#last_sync_pointers' do
    it 'initializes as empty' do
      expect(sync.last_sync_pointers).to eql({})
    end

    it 'initializes with provided pointers' do
      expect(partial_sync.last_sync_pointers).to eql(ptrs)
    end
  end

  # it 'test stubbed' do
  #   skip
  # end

  describe '#all_packets' do
    let(:fake_client) { instance_double(HTTP::Client) }
    let(:fake_results) do
      fixtures = %w[spec/fixtures/response-1.bin spec/fixtures/response-2.bin]
      fixtures.map { |f| instance_double(HTTP::Response, body: LocalFile.read(f)) }
    end

    before do
      allow(fake_client).to receive(:post).and_return(*fake_results)
      stub_const('HTTP', class_double(HTTP, headers: fake_client))
    end

    it 'retrieves a combined multi-page list of parsed packets from MFP' do
      counts = Hash.new(0)

      partial_sync.all_packets.each { |p| counts.store(p.class, counts[p.class] + 1) }

      expect(counts).to eql(
        MFP::Binary::DeleteItem         => 1007,
        MFP::Binary::MeasurementTypes   => 2,
        MFP::Binary::SyncResponse       => 2,
        MFP::Binary::UserPropertyUpdate => 2
      )
    end
  end
end
