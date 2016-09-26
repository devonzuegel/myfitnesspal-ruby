describe API::Builders::FoodOrchestrator, :db, :food_entry_packet do
  let(:user_id) { 9 }

  before do
    db[:users].insert(
      id:       user_id,
      username: 'dummy-username',
      password: 'dummy-password'
    )
  end

  let(:contents)     { LocalFile.read_yml(fixture('packets-tiny-sync.yml')) }
  let(:packet)       { API::Builders::Sync.new(contents, repository, user_id).packets.first }
  let(:orchestrator) { described_class.new(packet.to_h, repository, user_id) }

  describe '#call' do
    context 'simple sync' do
      it 'builds food portions' do
        expect { orchestrator.call }
          .to change { db[:food_portions].count }
          .by 15
      end

      it 'builds food' do
        expect { orchestrator.call }
          .to change { db[:foods].count }
          .by 1
      end

      it 'builds food entry' do
        expect { orchestrator.call }
          .to change { db[:food_entries].count }
          .by 1
      end
    end
  end
end
