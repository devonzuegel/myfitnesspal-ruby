require 'concord'

# Given a encoded sync API request, construct headers and a POST body.
module MFP
  class HttpRequestParams
    include Concord.new(:data)

    def url
      'https://www.myfitnesspal.com/iphone_api/synchronize'
    end

    def body
      <<~HEREDOC
        --#{mime_boundary}\r\n
        Content-Disposition: form-data; name="syncdata"; filename="syncdata.dat"\r\n
        Content-Type: application/octet-stream\r\n
        \r\n
        #{data}
        \r\n
        --#{mime_boundary}--\r\n
      HEREDOC
    end

    def headers
      {
        'User-Agent'     => 'Dalvik/1.6.0 (Linux; U; Android 4.4.2; sdk Build/KK)',
        'Content-Type'   => "multipart/form-data; boundary=#{mime_boundary}",
        'Content-Length' => body.length
      }
    end

    private

    def mime_boundary
      @mime_boundary ||= 78.times.map { [*('a'..'z')].sample }.join
    end
  end
end
