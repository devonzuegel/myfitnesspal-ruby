describe API::Builders::Sync, :db, :food_entry_packet do
  let(:user_id) { 9 }

  before do
    db[:users].insert(
      id:       user_id,
      username: 'dummy-username',
      password: 'dummy-password'
    )
  end

  let(:contents)     { LocalFile.read_yml(fixture('packets-tiny-sync.yml')) }
  let(:sync_builder) { described_class.new(contents, repository, user_id) }

  describe '.SUPPORTED_PACKETS' do
    it 'supports the expected packets and corresponding builders' do
      expect(described_class::SUPPORTED_PACKETS).to eql(
        MFP::Binary::FoodEntry => API::Builders::FoodEntry
      )
    end
  end

  describe '#packets' do
    let(:packets) { sync_builder.packets }

    it 'is a list of MFP::Binary::Packets' do
      packets.each { |p| expect(p.class).to be < MFP::Binary::Packet }
    end

    it 'filters all but supported packets' do
      master_food_ids = packets.map { |p| p.to_h.fetch(:master_food_id) }
      expect(master_food_ids).to eql [food_entry_pkt_hash[:master_food_id]]
    end
  end

  describe '#call' do
    it 'builds food portions' do
      expect { sync_builder.call }
        .to change { db[:food_portions].count }
        .by 15
    end

    it 'builds food' do
      expect { sync_builder.call }
        .to change { db[:foods].count }
        .by 1
    end

    it 'builds food entry' do
      expect { sync_builder.call }
        .to change { db[:food_entries].count }
        .by 1
    end
  end
end
