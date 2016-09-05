describe API::Builders::Food, :db, :food_entry_packet do
  let(:food_hash) { food_entry_pkt_hash.fetch(:food) }

  it 'validates params, which should be a hash containing Food details' do
    expect { described_class.call(food_hash, repository) }
      .to change { db[:foods].count }
      .by 1
  end

  it 'is has the expected output' do
    expect(described_class.call(food_hash, repository))
      .to eql(
        brand:          '',
        calories:       32.0,
        description:    'Strawberries, raw',
        grams:          100.0,
        master_food_id: 295_758_538,
        serialized:     "---\n:brand: ''\n:description: Strawberries, raw\n:flags: 3\n:"         \
                        "grams: 100.0\n:is_deleted: \n:is_meal: \n:is_public: \n:"               \
                        "master_food_id: 295758538\n:nutrients:\n  calcium: 1.600000023841858"   \
                        "\n  calories: 32.0\n  carbohydrates: 7.679999828338623\n  "             \
                        "cholesterol: 0.0\n  fat: 0.30000001192092896\n  fiber: 2.0\n  "         \
                        "iron: 2.277780055999756\n  monounsaturated_fat: 0.0430000014603138"     \
                        "\n  polyunsaturated_fat: 0.1550000011920929\n  potassium: 153.0\n  "    \
                        "protein: 0.6700000166893005\n  saturated_fat: 0.014999999664723873\n  " \
                        "sodium: 1.0\n  sugar: 4.889999866485596\n  trans_fat: 0.0\n  "          \
                        "vitamin_a: 0.23999999463558197\n  vitamin_c: 98.0\n:"                   \
                        "original_master_id: 9316\n:owner_user_master_id: 0\n:packet_type: "     \
                        "3\n:portions:\n- :amount: 1.0\n  :description: extra large "            \
                        "(1-5/8\" dia)\n  :fraction_int: 0\n  :gram_weight: 27.0\n  :"           \
                        "is_fraction: 0\n- :amount: 1.0\n  :description: cup(s)\n  "             \
                        ":fraction_int: 0\n  :gram_weight: 15200.0\n  :is_fraction: 0\n- "       \
                        ":amount: 1.0\n  :description: large (1-3/8\" dia)\n  :fraction_int"     \
                        ": 0\n  :gram_weight: 18.0\n  :is_fraction: 0\n- :amount: 1.0\n  "       \
                        ":description: small (1\" dia)\n  :fraction_int: 0\n  :gram_weight: "    \
                        "7.0\n  :is_fraction: 0\n:type: 0\n"
      )
  end
end
