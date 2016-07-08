require 'spike'
require 'codec'

RSpec.describe Spike do
  let(:response_fixture) do
    Pathname.new(__dir__).join('fixtures/response.bin').expand_path.read.b
  end

  it 'should create the expected count of each packet type' do
    packet_types = Hash.new(0)
    Codec.new(response_fixture).each_packet do |p|
      packet_types[Binary::Type.supported_types.fetch(p.packet_type)] += 1
    end

    expect(packet_types).to eq(
      Binary::Exercise           => 1,
      Binary::Food               => 54,
      Binary::FoodEntry          => 848,
      Binary::MealIngredients    => 10,
      Binary::MeasurementTypes   => 1,
      Binary::SyncResponse       => 1,
      Binary::UserPropertyUpdate => 1
    )
  end

  it 'Request should retrieve expected response (SKIPPED BY DEFAULT)', :skip do
    spike = Spike.new
    expect(spike.status).to eq 200
    expect(spike.response_body.length).to be >= 213_000
  end
end
