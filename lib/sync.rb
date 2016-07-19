require 'concord'
require 'http'
require 'securerandom'
require 'local_file'

require 'binary/sync_request'
require 'http_request_params'

module MFP
  class Sync
    include Concord.new(:username, :password)

    def response
      HTTP
        .headers(request.headers)
        .post(request.url, body: request.body)
    end

    private

    def request
      sync_request = Binary::SyncRequest.new(
        username:           username,
        password:           password,
        last_sync_pointers: {}
      )
      @request ||= HttpRequestParams.new(sync_request.packed)
    end
  end
end
