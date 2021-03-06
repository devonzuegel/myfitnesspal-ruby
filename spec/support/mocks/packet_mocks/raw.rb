require 'binary/packet'
require 'struct/packer'

module PacketMocks
  # Contains mocks for raw packets of each type
  module Raw
    extend MFP::Struct::Packer

    BAD_HEADER = [
      [1].pack('s>'),
      [500].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>'),
    ].join

    PACKED_MAGIC = [MFP::Binary::Packet::MAGIC].pack('s>')

    SIMPLE_MAP = [
      # Binary representation of { 2 => 'foobar' }
      "\x00\x01", # sync_pointer_count = 1
      "\x00\x02", # key = 2
      "\x00\x06", # String length = 6
      'foobar',
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
        pack_short(attrs.fetch(:api_version)),
        pack_long(attrs.fetch(:svn_revision)),
        pack_short(attrs.fetch(:unknown1)),
        pack_string(attrs.fetch(:username)),
        pack_string(attrs.fetch(:password)),
        pack_short(attrs.fetch(:flags)),
        attrs.fetch(:installation_uuid),
        pack_hash(attrs[:last_sync_pointers]),
      ].join
    end
    private_class_method(:body_from_hash)

    def self.headers_from_hash(attrs, body_length)
      [
        PACKED_MAGIC,
        pack_long(body_length + MFP::Binary::Packet::HEADER_SIZE),
        pack_short(attrs.fetch(:unknown1)),
        pack_short(attrs.fetch(:packet_type)),
      ].join
    end
    private_class_method(:headers_from_hash)
  end
end
