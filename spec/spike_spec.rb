require 'spike'
require 'codec'

RSpec.describe Spike do
  it 'Request should retrieve expected response (skipped by default)', :skip do
    spike = Spike.new
    expect(spike.status).to eq 200
    expect(spike.response_body.length).to be >= 213_000
  end

  # it 'does something' do
  #   response_fixture = Pathname.new(__dir__)
  #     .join('fixtures/response.bin')
  #     .expand_path
  #     .read
  #     .force_encoding('ASCII-8BIT')

  #   Codec.new(response_fixture).read_packets do |p|
  #     puts p
  #   end
  # end
end
