require 'bundler/setup'
require 'rspec'

require 'spike'

RSpec.describe Spike do
  it 'Expected response to work' do
    spike = Spike.new
    expect(spike.status).to eq 200
    expect(spike.response_body.length).to eq 213_187
  end
end
