require 'http'
require 'awesome_print'
require 'pathname'
require 'securerandom'

module RequestParams
  URL  = 'https://www.myfitnesspal.com/iphone_api/synchronize'

  def self.headers
    {
      'Content-Type' => "multipart/form-data; boundary=#{boundary}"
    }
  end

  def self.body
    "--#{boundary}\r\nContent-Disposition: form-data; name=\"syncdata\"; filename=\"syncdata.dat\"\r\nContent-Type: application/octet-stream\r\n\r\n\x04\xD3\x00\x00\x00D\x00\x01\x00\x01\x00\x06\x00\x00\x00\xED\x00\x02\x00\x10#{username}\x00\n#{password}\x00\x05(X\xAF\xD5<`F\x9D\x84\xE6\xE9\xE9\xE08\x95f\x00\x00\r\n--#{boundary}--\r\n"
  end

  def self.username
    ENV['MYFITNESSPAL_USERNAME']
  end

  def self.password
    ENV['MYFITNESSPAL_PASSWORD']
  end

  def self.boundary
    @boundary ||= SecureRandom.uuid
  end
end

class Spike
  def response
    @response ||= HTTP.headers(RequestParams.headers)
                      .post(RequestParams::URL, body: RequestParams.body)
  end

  def status
    response.status
  end

  def response_body
    response.to_str
  end
end
