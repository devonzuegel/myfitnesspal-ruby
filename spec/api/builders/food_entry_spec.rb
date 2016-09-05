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
      serialized:     'x' * 50,
      id:             food_id
    )
    db[:food_portions].insert(
      id:            portion_id,
      options_index: 1,
      description:   'dummy description',
      amount:        1.0,
      gram_weight:   1.0,
      serialized:    'x' * 50,
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
        user_id:    2,
        serialized: "---\n:food:\n  :brand: ''\n  :description: Strawberries, raw\n  :flags:"   \
                    " 3\n  :grams: 100.0\n  :is_deleted: \n  :is_meal: \n  :is_public: \n  "    \
                    ":master_food_id: 295758538\n  :nutrients:\n    calcium: 1.600000023841858" \
                    "\n    calories: 32.0\n    carbohydrates: 7.679999828338623\n    "          \
                    "cholesterol: 0.0\n    fat: 0.30000001192092896\n    fiber: 2.0\n    iron"  \
                    ": 2.277780055999756\n    monounsaturated_fat: 0.0430000014603138\n    "    \
                    "polyunsaturated_fat: 0.1550000011920929\n    potassium: 153.0\n    "       \
                    "protein: 0.6700000166893005\n    saturated_fat: 0.014999999664723873\n"    \
                    "    sodium: 1.0\n    sugar: 4.889999866485596\n    trans_fat: 0.0\n    "   \
                    "vitamin_a: 0.23999999463558197\n    vitamin_c: 98.0\n  :"                  \
                    "original_master_id: 9316\n  :owner_user_master_id: 0\n  :packet_type: 3"   \
                    "\n  :portions:\n  - :amount: 1.0\n    :description: extra large (1-5/8\" " \
                    "dia)\n    :fraction_int: 0\n    :gram_weight: 27.0\n    :is_fraction: 0\n" \
                    "  - :amount: 1.0\n    :description: cup(s)\n    :fraction_int: 0\n    "    \
                    ":gram_weight: 15200.0\n    :is_fraction: 0\n  - :amount: 1.0\n    "        \
                    ":description: large (1-3/8\" dia)\n    :fraction_int: 0\n    "             \
                    ":gram_weight: 18.0\n    :is_fraction: 0\n  - :amount: 1.0\n    "           \
                    ":description: small (1\" dia)\n    :fraction_int: 0\n    :gram_weight"     \
                    ": 7.0\n    :is_fraction: 0\n  :type: 0\n:date: '2016-08-12'\n:"            \
                    "master_food_id: 5655946676\n:meal_name: 21 to 24\n:packet_type: 5\n:"      \
                    "quantity: 15.0\n:weight_index: 2\n:user_id: 2\n:portion_id: 2\n"
      )
  end
end
