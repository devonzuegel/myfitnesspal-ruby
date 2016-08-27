describe MFP::Credentials do
  let(:boundary) { '-' * 36 }
  before { allow(SecureRandom).to receive(:hex).and_return(boundary) }

  let(:uri)            { 'https://www.myfitnesspal.com/iphone_api/synchronize' }
  let(:expected_body)  do
    "--------------------------------------\r\nContent-Disposition: form-data;" \
    " name=\"syncdata\";\nfilename=\"syncdata.dat\"\r\n\r\n\x04\xD3\x00\x00"    \
    "\x004\x00\x01\x00\x01\x00\x06\x00\x00\x00\xED\x00\x02\x00\x05uname\x00"    \
    "\x05pword\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\r\n----------------------------------------\r\n".b
  end

  describe '#messages' do
    let(:body) { LocalFile.read(fixture('good-creds.bin')) }

    it 'posts with the expected request body' do
      fake_response = instance_double(HTTP::Response, body: body)
      fake_client   = instance_double(HTTP::Client, post: fake_response)
      http          = class_double(HTTP, headers: fake_client)

      described_class.new('uname', 'pword', http).messages
      expect(fake_client).to have_received(:post).with(uri, body: expected_body)
      expect(http)
        .to have_received(:headers)
        .with('Content-Type' => "multipart/form-data; boundary=#{boundary}")
    end

    context 'good credentials' do
      let(:good_creds) do
        described_class.new('uname', 'pword', fake_http(body))
      end

      it 'is empty when credentials are valid' do
        expect(good_creds.messages).to eql({})
      end
    end

    context 'bad credentials' do
      let(:bad_creds) do
        fake_body =
          "\x04\xD3\x00\x00\x00\x1C\x00\x01\x00\x02\x00\x02\x00\x00\x00\x00\x00\x00\x00" \
          "\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        described_class.new('uname', 'pword', fake_http(fake_body))
      end

      it 'include :credentials when credentials are invalid' do
        expect(bad_creds.messages).to eql(credentials: 'Authentication failed')
      end
    end

    context 'badly formed HTTP response' do
      let(:creds) { described_class.new('uname', 'pword', fake_http('')) }

      it 'raise an EOFError' do
        msg = 'No packet of type Binary::SyncResponse found in response'
        expect { creds.messages }.to raise_error(EOFError, msg)
      end
    end
  end
end
