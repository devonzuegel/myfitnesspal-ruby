describe API::Mappers::LastSyncInfo, :db do
  before do
    db[:users].insert(
      id:       5,
      username: 'dummy-username',
      password: 'dummy-password'
    )
  end

  let(:last_sync_info_repo) { described_class.new(repository) }
  let(:attrs) do
    {
      id:              -1,
      user_id:         5,
      serialized_ptrs: 'x' * 50,
      date:            DateTime.parse('2016-08-21'),
    }
  end

  describe '#query' do
    context 'nothing inserted' do
      it 'returns an emtpy array when no foods are inserted' do
        expect(last_sync_info_repo.query({})).to eql([])
      end
    end

    context 'last_sync_info inserted' do
      before { db[:last_sync_info].insert(attrs) }

      it 'returns the last_sync_info inserted into the db' do
        expect(last_sync_info_repo.query({})).to eql [API::Models::LastSyncInfo.new(attrs)]
      end

      it 'returns emtpy array of foods when given conditions that do not match records' do
        expect(last_sync_info_repo.query(user_id: 123123123))
          .to eql([])
      end
    end
  end

  describe '#create' do
    it 'adds a last_sync_info to the db' do
      expect { last_sync_info_repo.create(attrs) }
        .to change { db[:last_sync_info].count }
        .by(1)
    end
  end
end
