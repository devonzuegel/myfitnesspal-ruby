module MFP
  class Credentials
    include Concord.new(:username, :password, :http), Memoizable

    def messages
      if response_packet.success?
        {}
      else
        { credentials: response_packet.status_message }
      end
    end

    private

    def response_packet
      Codec.new(response.body).each_packet { |pkt| return pkt }

      fail EOFError, 'No packet of type Binary::SyncResponse found in response'
    end
    memoize :response_packet

    def response
      http
        .headers(request.headers)
        .post(request.url, body: request.body)
    end

    def request
      sync_request = Binary::SyncRequest.new(username: username, password: password)
      HttpRequestParams.new(sync_request.packed)
    end
    memoize :request
  end
end
