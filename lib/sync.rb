require_relative 'local_file'
require_relative 'binary/sync_request'
require_relative 'http_request_params'
require_relative 'codec'

module MFP
  class Sync
    include Concord.new(:username, :password, :last_sync_pointers), Memoizable

    attr_reader :last_sync_pointers

    def initialize(username, password, last_sync_pointers = {})
      super(username, password, last_sync_pointers)
    end

    def all_packets
      packets = []
      first_page = true
      loop do
        packet_count = 0
        res = response
        Codec.new(res.body.to_s).each_packet do |packet|
          packets << packet

          if packet.class == Binary::SyncResponse
            @last_sync_pointers = packet.last_sync_pointers
          else
            packet_count += 1
            return packets if packet_count == 1000
          end
        end

        return packets if packet_count < PACKETS_PER_RESPONSE && !first_page
        first_page = false
      end
      packets
    end
    memoize :all_packets

    private

    PACKETS_PER_RESPONSE = 1_000

    def response
      request = new_request
      HTTP
        .headers(request.headers)
        .post(request.url, body: request.body)
    end

    def new_request
      sync_request = Binary::SyncRequest.new(
        username:           username,
        password:           password,
        last_sync_pointers: last_sync_pointers
      )
      HttpRequestParams.new(sync_request.packed)
    end
  end
end
