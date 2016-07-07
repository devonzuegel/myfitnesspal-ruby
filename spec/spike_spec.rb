require 'spike'
require 'codec'

RSpec.describe Spike do
  let(:response_fixture) do
    Pathname.new(__dir__)
      .join('fixtures/response.bin')
      .expand_path
      .read.b
  end

  it '...' do
    expect do
    Codec.new(response_fixture).read_packets do |p|
      # puts '---------------------------'.black; puts p.to_json
    end
    end
    .to raise_error NotImplementedError, "Type 11 is not supported"
  end

  it 'Request should retrieve expected response (SKIPPED BY DEFAULT)', :skip do
    spike = Spike.new
    expect(spike.status).to eq 200
    expect(spike.response_body.length).to be >= 213_000
  end
end
