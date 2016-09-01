describe API::Mappers::FoodPortion, :db do
  let(:portion_repo) { described_class.new(repository) }
  let(:attrs) do
    {
      id:            -1,
      options_index: 1,
      description:   'dummy description',
      amount:        1.0,
      gram_weight:   1.0,
      serialized:    'x' * 50,
      food_id:       1
    }
  end

  describe '#query' do
    context 'nothing inserted' do
      it 'returns an emtpy array when no foods are inserted' do
        expect(portion_repo.query({})).to eql([])
      end
    end

    context 'portion inserted' do
      before { db[:food_portions].insert(attrs) }

      it 'returns the portion inserted into the db' do
        expect(portion_repo.query({})).to eql [API::Models::FoodPortion.new(attrs)]
      end

      it 'returns emtpy array of foods when given conditions that do not match records' do
        expect(portion_repo.query(description: 'description-that-doesnt-exist'))
          .to eql([])
      end
    end
  end

  describe '#create' do
    it 'adds a portion to the db' do
      expect { portion_repo.create(attrs) }
        .to change { db[:food_portions].count }
        .by(1)
    end
  end
end
