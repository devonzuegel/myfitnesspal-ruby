require 'sync'

RSpec.describe MFP::Sync do
  let(:sync) { described_class.new(ENV['MFP_USERNAME'], ENV['MFP_PASSWORD']) }

  # it 'should sync all pages, not just the first' do
  #   expect(sync.response.status).to eq 200
  #   expect(sync.response.body.to_s.length).to be >= 213_000
  # end

  it 'test stubbed' do
    skip
  end

  it '...' do
    skip
    packets = sync.all_packets
    counts = Hash.new(0)
    packets.each do |packet|
      klass =  packet.class
      p packet.to_h[:date] if klass == MFP::Binary::FoodEntry
      counts.store(klass, counts[klass] + 1)
    end
    ap counts

    puts "packets.length = #{packets.length}"
  end
end
