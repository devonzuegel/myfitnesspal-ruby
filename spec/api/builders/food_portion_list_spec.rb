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
      grams:          1.0,
      serialized:     'x' * 50
    )
  end

  it 'inserts the list of portions into the db' do
    expect { described_class.call(portion_list, food_id, repository) }
      .to change { db[:food_portions].count }
      .by(portion_list.length)
  end

  let(:results_list) do
    [
      {
          amount:        1.0,
          description:   "extra large (1-5/8\" dia)",
          food_id:       3,
          gram_weight:   27.0,
          options_index: 0,
          serialized:    "---\n:amount: 1.0\n:description: extra large (1-5/8\" dia)\n:"         \
                         "fraction_int: 0\n:gram_weight: 27.0\n:is_fraction: 0\n:options_index:" \
                         " 0\n:food_id: 3\n"
      },
      {
        errors: {
          amount:      [ 'is missing' ],
          description: [ 'is missing' ],
          gram_weight: [ 'is missing' ],
          serialized:  [ 'size cannot be less than 50' ]
        }
      }
    ]
  end

  it 'returns the results of each individual portion build' do
    expect(described_class.call([portion_list.first, { a: 'b' }], food_id, repository))
      .to eql(results_list)
  end
end
