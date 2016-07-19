require 'concord'
require 'http'
require 'securerandom'
require 'local_file'

require 'binary/sync_request'
require 'http_request_params'
require 'codec'

module MFP
  class Sync
    include Concord.new(:username, :password, :last_sync_pointers)

    def initialize(username, password, last_sync_pointers = {})
      super(username, password, last_sync_pointers)
    end

    def response
      request = new_request
      HTTP
        .headers(request.headers)
        .post(request.url, body: request.body)
    end

    def all_packets
      packets = []
      loop do
        packet_count = 0

        Codec.new(response.body.to_s).each_packet do |packet|
          packets << packet.to_h
          if packet.class == Binary::SyncResponse
            @last_sync_pointers = packet.last_sync_pointers
          else
            packet_count += 1
          end
        end

        return packets if packet_count == 0

        puts 'last packet:'.black
        p packets.last.to_h

        puts
      end
    end

    private

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
