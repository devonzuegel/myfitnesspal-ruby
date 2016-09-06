describe API::Mappers::FoodPortion, :db do
  before do
    db[:foods].insert(
      id:             3,
      master_food_id: 123,
      description:    'dummy description',
      brand:          'dummy brand',
      calories:       1.0,
      grams:          1.0,
      serialized:     'x' * 50
    )
  end

  let(:portion_repo) { described_class.new(repository) }
  let(:attrs) do
    {
      id:            3,
      options_index: 1,
      description:   'dummy description',
      amount:        1.0,
      gram_weight:   1.0,
      serialized:    'x' * 50,
      food_id:       3
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

  describe '#available?' do
    before { db[:food_portions].insert(attrs) }

    it 'is false when the food_id AND options_index are taken' do
      expect(portion_repo.available?(attrs)).to be false
    end

    it 'is true when the food_id is not taken' do
      expect(portion_repo.available?(attrs.merge(food_id: 123))).to be true
    end

    it 'is true when the options_index is not taken' do
      expect(portion_repo.available?(attrs.merge(options_index: 123))).to be true
    end

    it 'is true when the food_id AND options_index are not taken' do
      portion = attrs.merge(options_index: 123, food_id: 123)
      expect(portion_repo.available?(portion)).to be true
    end
  end
end
