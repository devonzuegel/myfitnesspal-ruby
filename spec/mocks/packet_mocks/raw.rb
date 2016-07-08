require 'binary/packet'

module PacketMocks
  # Contains mocks for raw packets of each type
  module Raw
    BAD_HEADER = [
      [1].pack('s>'),
      [500].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>')
    ].join

    PACKED_MAGIC = [Binary::Packet::MAGIC].pack('s>')

    SIMPLE_MAP = [
      # Binary representation of { 2 => 'foobar' }
      "\x00\x01", # sync_pointer_count = 1
      "\x00\x02", # key = 2
      "\x00\x06", # String length = 6
      'foobar'
    ].join

    def self.from_hash(json)
      body    = body_from_hash(json)
      headers = headers_from_hash(json, body.length)
      "#{headers}#{body}"
    end

    def self.sync_request_default
      from_hash(PacketMocks::Hash::SYNC_REQUEST_DEFAULT.merge(packet_type: 1))
    end

    def self.sync_request_updated
      from_hash(PacketMocks::Hash::SYNC_REQUEST_UPDATED.merge(packet_type: 1))
    end

    def self.body_from_hash(attrs)
      [
        Struct.pack_short(attrs.fetch(:api_version)),
        Struct.pack_long(attrs.fetch(:svn_revision)),
        Struct.pack_short(attrs.fetch(:unknown1)),
        Struct.pack_string(attrs.fetch(:username)),
        Struct.pack_string(attrs.fetch(:password)),
        Struct.pack_short(attrs.fetch(:flags)),
        attrs.fetch(:installation_uuid),
        Struct.pack_hash(attrs[:last_sync_pointers])
      ].join
    end
    private_class_method(:body_from_hash)

    def self.headers_from_hash(attrs, body_length)
      [
        PACKED_MAGIC,
        Struct.pack_long(body_length + Codec::PACKET_HEADER_SIZE),
        Struct.pack_short(attrs.fetch(:unknown1)),
        Struct.pack_short(attrs.fetch(:packet_type)),
      ].join
    end
    private_class_method(:headers_from_hash)
  end
end
