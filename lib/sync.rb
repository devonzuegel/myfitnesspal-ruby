require 'concord'
require 'http'
require 'securerandom'

module MFP
  class Sync
    include Concord.new(:username, :password)

    URL = 'https://www.myfitnesspal.com/iphone_api/synchronize'.freeze

    def response
      @response ||= HTTP.headers(headers).post(URL, body: request_body)
    end

    def get_packets
      sync_request = Binary::SyncRequest.new(username: username, password: password)
      http_request_params = HttpRequestParams(sync_request.packed)

      # HTTP
      #   .headers(http_request_params.headers)
      #   .post(http_request_params.url, body: http_request_params.body)
    end

    private

    def headers
      { 'Content-Type' => "multipart/form-data; boundary=#{boundary}" }
    end

    def request_body
      <<~HEREDOC
        --#{boundary}\r\nContent-Disposition: form-data; name=\"syncdata\";
        filename=\"syncdata.dat\"\r\nContent-Type: application/octet-
        stream\r\n\r\n\x04\xD3\x00\x00\x00D\x00\x01\x00\x01\x00\x06#{
        "\x00\x00\x00\xED\x00\x02\x00\x10"}#{username}\x00\n#{password}#{
        "\x00\x05(X\xAF\xD5<`F\x9D\x84\xE6\xE9\xE9\xE08\x95f\x00\x00\r\n"}
        --#{boundary}--\r\n
      HEREDOC
    end

    def boundary
      @boundary ||= SecureRandom.uuid
    end
  end
end
