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
    # expect do
      Codec.new(response_fixture).read_packets do |p|
        type = p.packet_type
        puts "Type #{type}: #{Binary::Type.supported_types.fetch(type)}".black

        # puts '---------------------------'.black; ap p.to_h
      end
    # end
    # .to raise_error NotImplementedError, "Type 4 is not supported"
  end

  it 'Request should retrieve expected response (SKIPPED BY DEFAULT)', :skip do
    spike = Spike.new
    expect(spike.status).to eq 200
    expect(spike.response_body.length).to be >= 213_000
  end
end
