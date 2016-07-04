require 'bundler/setup'
require 'abstract_method'

module Binary
  # Base class for `Codec` packets. Sync API requests and responses are a
  # series of packets.
  class Packet < Binary::Object
    # Magic number, marks the beginning of a packet.
    MAGIC = 0x04D3

    # Packet type number. A packet header lists it's type - `packet_type` is
    # used to associate it with the appropriate `BinaryPacket` subclass.
    PACKET_TYPE = nil

    def initialize
      @packet_start  = nil
      @packet_length = nil
      super
    end

    def write_packet_to_codec(codec)
      @packet_start = codec.position
      codec.write_2_byte_int(MAGIC)       # Magic number
      codec.write_4_byte_int(0)           # Length placeholder
      codec.write_2_byte_int(1)           # Unknown
      codec.write_2_byte_int(PACKET_TYPE) # Packet type
      write_body_to_codec(codec)

      packet_end = codec.temporary_position(@packet_start + 2)
      @packet_length = packet_end - @packet_start
      codec.write_4_byte_int(@packet_length) # Length
    end
  end
end
