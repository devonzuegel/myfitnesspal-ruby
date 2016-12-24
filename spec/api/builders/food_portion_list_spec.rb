describe API::Builders::FoodPortionList, :db, :food_entry_packet do
  let(:food_hash)     { food_entry_pkt_hash.fetch(:food) }
  let(:portion_list)  { food_hash.fetch(:portions) }
  let(:food_id)       { 3 }

  before do
    db[:foods].insert(
      id:             food_id,
      master_food_id: 123,
      description:    'dummy description',
      brand:          'dummy brand',
      calories:       1.0,
      grams:          1.0
    )
  end

  it 'inserts the list of portions into the db' do
    expect { described_class.call(portion_list, food_id, repository) }
      .to change { db[:food_portions].count }
      .by(portion_list.length)
  end

  let(:expected_results_list) do
    [
      {
        amount:        1.0,
        description:   'extra large (1-5/8" dia)',
        food_id:       3,
        gram_weight:   27.0,
        options_index: 0
      },
      {
        errors: {
          description: ['is missing'],
          amount:      ['is missing'],
          gram_weight: ['is missing']
        }
      }
    ]
  end

  it 'returns the results of each individual portion build' do
    results_list =
      described_class
        .call([portion_list.first, { a: 'b' }], food_id, repository)
        .map { |p| p.reject { |k| k == :id } }

    expect(results_list).to eql(expected_results_list)
  end

  context 'portion already inserted' do
    before do
      described_class.call([portion_list.first], food_id, repository)
    end

    it 'skips duplicate portions' do
      expect { described_class.call([portion_list.first], food_id, repository) }
        .to change { db[:food_portions].count }
        .by 0
    end
  end
end
