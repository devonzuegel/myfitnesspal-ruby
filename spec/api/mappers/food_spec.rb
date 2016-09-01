describe API::Mappers::Food, :db do
  let(:food_repo) { described_class.new(repository) }
  let(:attrs) do
    {
      master_food_id: 123,
      description:    'dummy description',
      brand:          'dummy brand',
      calories:       1.0,
      grams:          1.0,
      serialized:     'x' * 50,
      id:             -1
    }
  end

  describe '#query' do
    context 'nothing inserted' do
      it 'returns an emtpy array when no foods are inserted' do
        expect(food_repo.query({})).to eql([])
      end
    end

    context 'food inserted' do
      before { db[:foods].insert(attrs) }

      it 'returns the food inserted into the db' do
        expect(food_repo.query({})).to eql [API::Models::Food.new(attrs)]
      end

      it 'returns emtpy array of foods when given conditions that do not match records' do
        expect(food_repo.query(description: 'description-that-doesnt-exist'))
          .to eql([])
      end
    end
  end

  describe '#create' do
    it 'adds a food to the db' do
      expect { food_repo.create(attrs) }
        .to change { db[:foods].count }
        .by(1)
    end
  end
end
