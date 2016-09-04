describe API::Mappers::FoodEntry, :db do
  before do
    db[:foods].insert(
      master_food_id: 123,
      description:    'dummy description',
      brand:          'dummy brand',
      calories:       1.0,
      grams:          1.0,
      serialized:     'x' * 50,
      id:             3
    )
    db[:food_portions].insert(
      id:            2,
      options_index: 1,
      description:   'dummy description',
      amount:        1.0,
      gram_weight:   1.0,
      serialized:    'x' * 50,
      food_id:       3
    )
  end
  let(:entries_repo) { described_class.new(repository) }
  let(:attrs) do
    {
      id:              -1,
      date:            DateTime.parse('2016-08-21'),
      meal_name:       'dummy meal name',
      quantity:        1.0,
      serialized:      'x' * 50,
      food_portion_id: 2
    }
  end

  describe '#query' do
    context 'nothing inserted' do
      it 'returns an emtpy array when no foods are inserted' do
        expect(entries_repo.query({})).to eql([])
      end
    end

    context 'entry inserted' do
      before { db[:food_entries].insert(attrs) }

      it 'returns the entry inserted into the db' do
        expect(entries_repo.query({})).to eql [API::Models::FoodEntry.new(attrs)]
      end

      it 'returns emtpy array of foods when given conditions that do not match records' do
        expect(entries_repo.query(meal_name: 'meal_name-that-doesnt-exist'))
          .to eql([])
      end
    end
  end

  describe '#create' do
    it 'adds a entry to the db' do
      expect { entries_repo.create(attrs) }
        .to change { db[:food_entries].count }
        .by(1)
    end
  end
end
