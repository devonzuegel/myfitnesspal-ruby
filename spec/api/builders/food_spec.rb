describe API::Builders::Food, :db, :food_entry_packet do
  let(:food_hash) { food_entry_pkt_hash.fetch(:food) }

  it 'validates params, which should be a hash containing Food details' do
    expect { described_class.call(food_hash, repository) }
      .to change { db[:foods].count }
      .by 1
  end

  it 'is has the expected output' do
    expect(described_class.call(food_hash, repository).reject { |k| k == :id })
      .to eql(
        brand:          '',
        calories:       32.0,
        description:    'Strawberries, raw',
        grams:          100.0,
        master_food_id: 295_758_538
      )
  end
end
