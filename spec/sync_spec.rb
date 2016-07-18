require 'sync'

RSpec.describe MFP::Sync do
  it 'retrieves expected response' do
    expect(ENV['MYFITNESSPAL_USERNAME']).to_not eq nil
    expect(ENV['MYFITNESSPAL_PASSWORD']).to_not eq nil

    sync = described_class.new(ENV['MYFITNESSPAL_USERNAME'], ENV['MYFITNESSPAL_PASSWORD'])
    expect(sync.response.status).to eq 200
    expect(sync.response.body.to_s.length).to be >= 213_000
  end

  it 'should sync all pages, not just the first' do
    skip
  end
end
