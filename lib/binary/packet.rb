require 'bundler/setup'
require 'abstract_method'
require 'concord'

module Binary
  # Base class for `Codec` packets. Sync API requests and responses are a
  # series of packets.
  class Packet
    # :packet_type is an integer used to associate the packet with the
    # appropriate `BinaryPacket` subclass. A packet header lists its type.
    include Concord.new(:packet_type, :packet_start, :packet_length)

    UUID_LENGTH = 16

    abstract_method :set_default_values
    abstract_method :read_body_from_codec
    abstract_method :write_body_to_codec
    abstract_method :to_json

    # Magic number, marks the beginning of a packet.
    MAGIC = 0x04D3

    def initialize(packet_type, packet_start, packet_length)
      set_default_values
      super(packet_type, packet_start, packet_length)
    end

    def to_json
      {
        packet_type:   packet_type,
        packet_start:  packet_start,
        packet_length: packet_length
      }
    end

    def write_packet_to_codec(codec)
      @packet_start = codec.position
      codec.write_2_byte_int(MAGIC)       # Magic number
      codec.write_4_byte_int(0)           # Length placeholder
      codec.write_2_byte_int(1)           # Unknown
      codec.write_2_byte_int(packet_type) # Packet type
      write_body_to_codec(codec)

      packet_end = codec.temporary_position(@packet_start + 2)
      @packet_length = packet_end - @packet_start
      codec.write_4_byte_int(@packet_length) # Length
    end

    def self.generate_uuid
      SecureRandom.hex(UUID_LENGTH / 2)
    end
  end
end
