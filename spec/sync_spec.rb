require 'sync'
require 'codec'

RSpec.describe Sync do
  let(:response_fixture) do
    Pathname.new(__dir__).join('fixtures/response.bin').expand_path.read.b
  end

  it 'should create the expected count of each packet type' do
    packet_type_counts = Hash.new(0)
    Codec.new(response_fixture).each_packet do |p|
      packet_type_counts[Binary::Type.supported_types.fetch(p.packet_type)] += 1
    end

    expect(packet_type_counts).to eq(
      Binary::Exercise           => 1,
      Binary::Food               => 54,
      Binary::FoodEntry          => 848,
      Binary::MealIngredients    => 10,
      Binary::MeasurementTypes   => 1,
      Binary::SyncResponse       => 1,
      Binary::UserPropertyUpdate => 1
    )
  end

  it 'Request should retrieve expected response (SKIPPED BY DEFAULT)' do
    sync = Sync.new(ENV['MYFITNESSPAL_USERNAME'], ENV['MYFITNESSPAL_PASSWORD'])
    expect(sync.response.status).to eq 200
    expect(sync.response.body.to_s.length).to be >= 213_000
  end
end
