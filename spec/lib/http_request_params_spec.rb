require 'http_request_params'

describe MFP::HttpRequestParams do
  let(:dummy_boundary) { 'x' * 16 }
  let(:http_request_params) { described_class.new('DATA', dummy_boundary) }

  it 'builds request headers' do
    expect(http_request_params.url).to eql 'https://www.myfitnesspal.com/iphone_api/synchronize'
  end

  it 'builds request headers' do
    expect(http_request_params.headers).to eql(
      'Content-Type' => "multipart/form-data; boundary=#{dummy_boundary}"
    )
  end

  it 'builds a request body' do
    expect(http_request_params.body).to eql(
      "--#{dummy_boundary}\r\n"                               \
      "Content-Disposition: form-data; name=\"syncdata\";\n"  \
      "filename=\"syncdata.dat\"\r\n\r\n"                     \
      "DATA\r\n"                                              \
      "--#{dummy_boundary}--\r\n"
    )
  end
end
