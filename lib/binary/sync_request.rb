require 'bundler/setup'
require 'abstract_method'

require 'binary/packet'
require 'binary/type'
require 'colorize'

module Binary
  class SyncRequest < Binary::Packet
    PACKET_TYPE = Binary::Type::SYNC_REQUEST

    def initialize
      super(PACKET_TYPE)
    end

    def to_h
      super.merge(
        api_version:            @api_version,
        svn_revision:           @svn_revision,
        unknown1:               @unknown1,
        username:               @username,
        password:               @password,
        flags:                  @flags,
        installation_uuid:      @installation_uuid,
        last_sync_pointers:     @last_sync_pointers
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

    def write_body_to_codec(_codec)
      fail NotImplementedError
      # codec.write_2_byte_int(@api_version)
      # codec.write_4_byte_int(@svn_revision)
      # codec.write_2_byte_int(@unknown1)
      # codec.write_string(@username)
      # codec.write_string(@password)
      # codec.write_2_byte_int(@flags)
      # codec.write_uuid(@installation_uuid)
      # codec.write_2_byte_int(@last_sync_pointers.length)
      # codec.write_map(
      #   codec.write_string,
      #   codec.write_string,
      #   @last_sync_pointers
      # )
    end
  end
end
