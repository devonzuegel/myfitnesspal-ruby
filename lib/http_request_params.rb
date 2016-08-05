require 'concord'

# Given a encoded sync API request, construct headers and a POST body.
module MFP
  class HttpRequestParams
    include Concord.new(:data, :boundary)

    def initialize(data, boundary = nil)
      super(data, boundary || SecureRandom.hex(36))
    end

    def url
      'https://www.myfitnesspal.com/iphone_api/synchronize'
    end

    def body
      "--#{boundary}\r\nContent-Disposition: form-data; name=\"syncdata\";\n"          \
      "filename=\"syncdata.dat\"\r\n\r\n#{data}\r\n"                \
      "--#{boundary}--\r\n"
    end

    def headers(b = nil) # TODO
      {
        'Content-Type' => "multipart/form-data; boundary=#{b || boundary}"
      }
    end
  end
end
