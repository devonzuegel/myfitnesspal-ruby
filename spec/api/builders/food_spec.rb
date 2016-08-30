describe API::Builders::Food do
  let(:nutrients) do
    {
      'calcium'             => 1.600000023841858,
      'calories'            => 32.0,
      'carbohydrates'       => 7.679999828338623,
      'cholesterol'         => 0.0,
      'fat'                 => 0.30000001192092896,
      'fiber'               => 2.0,
      'iron'                => 2.277780055999756,
      'monounsaturated_fat' => 0.0430000014603138,
      'polyunsaturated_fat' => 0.1550000011920929,
      'potassium'           => 153.0,
      'protein'             => 0.6700000166893005,
      'saturated_fat'       => 0.014999999664723873,
      'sodium'              => 1.0,
      'sugar'               => 4.889999866485596,
      'trans_fat'           => 0.0,
      'vitamin_a'           => 0.23999999463558197,
      'vitamin_c'           => 98.0
    }
  end

  let(:portions) do
    [
      {
        amount:       1.0,
        description:  "extra large (1-5/8\" dia)",
        fraction_int: 0,
        gram_weight:  27.0,
        is_fraction:  0
      },
      {
        amount: 1.0,
        description:  'cup(s)',
        fraction_int: 0,
        gram_weight:  15200.0,
        is_fraction:  0
      },
      {
        amount: 1.0,
        description:  "large (1-3/8\" dia)",
        fraction_int: 0,
        gram_weight:  18.0,
        is_fraction:  0
      },
      {
        amount: 1.0,
        description:  "small (1\" dia)",
        fraction_int: 0,
        gram_weight:  7.0,
        is_fraction:  0
      }
    ]
  end

  let(:packet_hash) do
    {
      food: {
        brand:                  "",
        description:            "Strawberries, raw",
        flags:                  3,
        grams:                  100.0,
        is_deleted:             nil,
        is_meal:                nil,
        is_public:              nil,
        master_food_id:         295758538,
        nutrients:              nutrients,
        original_master_id:     9316,
        owner_user_master_id:   0,
        packet_type:            3,
        portions:               portions,
        type:                   0
        },
        date: "2016-08-12",
        master_food_id: 5655946676,
        meal_name:      "21 to 24",
        packet_type:    5,
        quantity:       15.0,
        weight_index:   2
      }

    end

  it 'validates params, which should be a hash containing Food details' # do
    # ap packet_hash
    # LocalFile.read_yml(fixture('packets-partial-sync.yml')).each do |packet|
    #   next unless packet.class == MFP::Binary::FoodEntry
    #   next unless packet.to_h[:food][:description] == 'Strawberries, raw'
    #   ap packet.to_h#.delete_if {|k, v| k == :food }
    #   break
    # end
  # end
end
