require 'sync'

RSpec.describe MFP::Sync do
  let(:sync) do
    described_class.new(ENV['MYFITNESSPAL_USERNAME'], ENV['MYFITNESSPAL_PASSWORD'])
  end

  it 'retrieves expected response', :skip do
    expect(sync.response.status).to eq 200
    expect(sync.response.body.to_s.length).to be >= 213_000
  end

  it 'should sync all pages, not just the first', :skip do
    sync.get_packets
    # puts "#{sync.get_packets}".yellow
  end
end
