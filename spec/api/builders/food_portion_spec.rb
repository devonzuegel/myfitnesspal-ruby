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
      grams:          1.0
    )
  end

  it 'inserts the portion into the db' do
    expect { described_class.call(portion_hash, options_index, food_id, repository) }
      .to change { db[:food_portions].count }
      .by 1
  end

  it 'is has the expected output' do
    output =
      described_class
        .call(portion_hash, options_index, food_id, repository)
        .reject { |k| k == :id }

    expected_output = {
        amount:        1.0,
        description:   'extra large (1-5/8" dia)',
        food_id:       3,
        gram_weight:   27.0,
        options_index: 0
    }

    expect(output).to eql(expected_output)
  end
end
