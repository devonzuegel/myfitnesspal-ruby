require 'bundler/setup'
require 'abstract_method'

require 'binary/packet'
require 'binary/type'
require 'struct/reader'

module MFP
  module Binary
    class SyncRequest < Binary::Packet
      PACKET_TYPE = Binary::Type::SYNC_REQUEST

      def initialize(username: '', password: '', last_sync_pointers: {})
        super(PACKET_TYPE)
        @username = username
        @password = password
        @last_sync_pointers = last_sync_pointers
      end

      def to_h
        super.merge(
          api_version:        @api_version,
          svn_revision:       @svn_revision,
          unknown1:           @unknown1,
          username:           @username,
          password:           @password,
          flags:              @flags,
          installation_uuid:  @installation_uuid,
          last_sync_pointers: @last_sync_pointers
        )
      end

      def set_default_values
        @api_version        = 6
        @svn_revision       = 237
        @unknown1           = 2
        @username           = ''
        @password           = ''
        @flags              = 0x5
        @installation_uuid  = Binary::Packet.generate_uuid
        @last_sync_pointers = {}
      end

      def read_body_from_codec(codec)
        @api_version        = codec.read_2_byte_int
        @svn_revision       = codec.read_4_byte_int
        @unknown1           = codec.read_2_byte_int
        @username           = codec.read_string
        @password           = codec.read_string
        @flags              = codec.read_2_byte_int
        @installation_uuid  = codec.read_uuid
        @last_sync_pointers = codec.read_map(read_key: -> { codec.read_string })
      end

      def packed
        [
          MFP::Struct::Reader.pack_short(@api_version),
          MFP::Struct::Reader.pack_long(@svn_revision),
          MFP::Struct::Reader.pack_short(@unknown1),
          MFP::Struct::Reader.pack_string(@username),
          MFP::Struct::Reader.pack_string(@password),
          MFP::Struct::Reader.pack_short(@flags),
          MFP::Struct::Reader.pack_string(@installation_uuid),
          MFP::Struct::Reader.pack_short(@last_sync_pointers.length),
          MFP::Struct::Reader.pack_hash(@last_sync_pointers, pack_key: -> (str) { pack_string(str) })
        ].join
      end
    end

    private

    attr_reader :username, :password
  end
end
