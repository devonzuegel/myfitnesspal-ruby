require 'http_request_params'

RSpec.describe MFP::HttpRequestParams do
  let(:http_request_params) { described_class.new('DATA') }

  before { srand(67_809) }

  it 'builds request headers' do
    expect(http_request_params.url).to eql 'https://www.myfitnesspal.com/iphone_api/synchronize'
  end

  it 'builds request headers' do
    expected_headers = {
      'Content-Length' => 295,
      'User-Agent'     => 'Dalvik/1.6.0 (Linux; U; Android 4.4.2; sdk Build/KK)',
      'Content-Type'   => 'multipart/form-data; boundary='          \
                          'snrpxxencwwfzmgvyuexjiplleisiqtpcmegajd' \
                          'wwvlebwdywrvaqslamktyfcjpyzhndadlbajylm'
    }

    expect(http_request_params.headers).to eql(expected_headers)
  end

  it 'builds a request body' do
    expect(http_request_params.body).to eql(
      '--snrpxxencwwfzmgvyuexjiplleisiqtpcmegajdwwvlebwdywrvaqslamktyfcjpyzhndadlbajyl'     \
      "m\r\n\nContent-Disposition: form-data; name=\"syncdata\"; filename=\"syncdata.dat\"" \
      "\r\n\nContent-Type: application/octet-stream\r\n\n\r\n\nDATA\n\r\n\n--"              \
      "snrpxxencwwfzmgvyuexjiplleisiqtpcmegajdwwvlebwdywrvaqslamktyfcjpyzhndadlbajylm--\r\n\n"
    )
  end
end
