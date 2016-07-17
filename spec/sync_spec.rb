require 'sync'
require 'codec'
require 'local_file'

RSpec.describe Sync do
  let(:response_fixture) { LocalFile.read('spec/fixtures/response.bin') }

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

  xit 'retrieves expected response' do
    expect(ENV['MYFITNESSPAL_USERNAME']).to_not eq nil
    expect(ENV['MYFITNESSPAL_PASSWORD']).to_not eq nil

    sync = Sync.new(ENV['MYFITNESSPAL_USERNAME'], ENV['MYFITNESSPAL_PASSWORD'])
    expect(sync.response.status).to eq 200
    expect(sync.response.body.to_s.length).to be >= 213_000
  end

  it 'should sync all pages, not just the first'
end
