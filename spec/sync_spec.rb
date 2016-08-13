require 'sync'

RSpec.describe MFP::Sync do
  let(:ptrs) do
    {
      'deleted_item'   => '2439954815',
      'diary_note'     => '2016-08-13 00:29:29 UTC',
      'exercise'       => '1018692',
      'exercise_entry' => '2170949139',
      'food'           => '318556366',
      'food_entry'     => '5655611135',
      'measurement'    => '2016-08-13 00:24:45 UTC',
      'user_property'  => '2016-07-03 22:20:44 UTC',
      'user_status'    => '',
      'water_entry'    => '2014-12-25 01:20:59 UTC'
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

  # it 'should sync all pages, not just the first' do
  #   expect(sync.response.status).to eq 200
  #   expect(sync.response.body.to_s.length).to be >= 213_000
  # end

  # it 'test stubbed' do
  #   skip
  # end

  it 'retrieves all parsed packets from MFP' do
    skip

    packets = partial_sync.all_packets
    counts = Hash.new(0)
    packets.each do |packet|
      klass = packet.class
      # p packet.to_h[:date] if klass == MFP::Binary::FoodEntry
      counts.store(klass, counts[klass] + 1)
    end
    ap counts
  end
end
