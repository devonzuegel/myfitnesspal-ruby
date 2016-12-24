describe API::Builders::FoodEntry, :db, :food_entry_packet do
  let(:food_id)    { 3 }
  let(:portion_id) { 2 }
  let(:user_id)    { 2 }

  before do
    db[:foods].insert(
      master_food_id: 123,
      description:    'dummy description',
      brand:          'dummy brand',
      calories:       1.0,
      grams:          1.0,
      id:             food_id
    )
    db[:food_portions].insert(
      id:            portion_id,
      options_index: 1,
      description:   'dummy description',
      amount:        1.0,
      gram_weight:   1.0,
      food_id:       food_id
    )
    db[:users].insert(
      id:       user_id,
      username: 'dummy-username',
      password: 'dummy-password'
    )
  end

  it 'inserts the entry into the db' do
    expect { described_class.call(food_entry_pkt_hash, portion_id, user_id, repository) }
      .to change { db[:food_entries].count }
      .by 1
  end

  it 'is has the expected output' do
    built_food_entry = described_class.call(food_entry_pkt_hash, portion_id, user_id, repository)
    expect(built_food_entry)
      .to eql(
        date:       Date.parse('2016-08-12'),
        meal_name:  '21 to 24',
        portion_id: 2,
        id:         built_food_entry.fetch(:id),
        quantity:   15.0,
        user_id:    2
      )
  end
end
