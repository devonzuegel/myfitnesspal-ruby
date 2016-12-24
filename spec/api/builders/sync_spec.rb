describe API::Builders::Sync, :mock_db, :food_entry_packet do
  let(:user_id)      { 9 }
  let(:contents)     { LocalFile.read_yml(fixture('packets-tiny-sync.yml')) }
  let(:sync_builder) { described_class.new(contents, user_id) }

  describe '.SUPPORTED_PACKETS' do
    it 'supports the expected packets and corresponding builders' do
      expected = { MFP::Binary::FoodEntry => API::Builders::FoodEntry }
      expect(described_class::SUPPORTED_PACKETS).to eql(expected)
    end
  end

  describe '#packets' do
    let(:packets) { sync_builder.packets }

    it 'is a list of MFP::Binary::Packets' do
      packets.each { |p| expect(p.class).to be < MFP::Binary::Packet }
    end

    it 'is a list of MFP::Binary::FoodEntrys' do
      packets.each { |p| expect(p.class).to eql MFP::Binary::FoodEntry }
    end

    it 'is as long as we expect' do
      expect(packets.length).to eql 1
    end

    it 'filters all but supported packets' do
      master_food_ids = packets.map { |p| p.to_h.fetch(:master_food_id) }
      expect(master_food_ids).to eql [food_entry_pkt_hash[:master_food_id]]
    end
  end

  describe '#call' do
    it 'enqueues the packets to be built and persisted' do
      sync_builder.call
      workers_args = Sidekiq::Queues['default'].map { |q| q['args'] }
      expect(workers_args.first).to eql([
        JSON.parse(JSON[sync_builder.packets.first.to_h]),
        user_id,
      ])
    end
  end
end
