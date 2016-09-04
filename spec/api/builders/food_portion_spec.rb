describe API::Builders::FoodPortion, :db, :food_entry_packet do
  let(:food_hash)     { food_entry_pkt_hash.fetch(:food) }
  let(:portion_hash)  { food_hash.fetch(:portions).first }
  let(:food_id)       { 3 }
  let(:options_index) { 0 }

  before do
    db[:foods].insert(
      id:             food_id,
      master_food_id: 123,
      description:    'dummy description',
      brand:          'dummy brand',
      calories:       1.0,
      grams:          1.0,
      serialized:     'x' * 50
    )
  end

  it 'validates params, which should be a hash containing Food details' do
    expect { described_class.call(portion_hash, options_index, food_id, repository) }
      .to change { db[:food_portions].count }
      .by 1
  end

  it 'is has the expected output' do
    expect(described_class.call(portion_hash, options_index, food_id, repository))
      .to eql(
        amount:        1.0,
        description:   "extra large (1-5/8\" dia)",
        food_id:       3,
        gram_weight:   27.0,
        options_index: 0,
        serialized:    "---\n:amount: 1.0\n:description: extra large (1-5/8\" dia)\n:"         \
                       "fraction_int: 0\n:gram_weight: 27.0\n:is_fraction: 0\n:options_index:" \
                       " 0\n:food_id: 3\n"
      )
  end
end
