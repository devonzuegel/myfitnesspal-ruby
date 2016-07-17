require 'bundler/setup'
require 'abstract_method'

require 'binary/packet'
require 'binary/type'

module MFP
  module Binary
    class UnknownPacket < Binary::Packet
  #     def set_default_values
  #       @bytes = ''
  #     end

  #     def write_packet_to_codec(codec)
  #       packet_start = codec.position
  #       codec.write_2_byte_int(MAGIC)       # Magic number
  #       codec.write_4_byte_int(0)           # Length placeholder
  #       codec.write_2_byte_int(1)           # Unknown
  #       codec.write_2_byte_int(PACKET_TYPE) # Packet type
  #       write_body_to_codec(codec)

  #       packet_end = codec.temporary_position(packet_start + 2)
  #       codec.write_4_byte_int(packet_end - packet_start) # Length
  #     end
  #   end

  #   def read_body_from_codec(codec)
  #     @bytes = codec.read_bytes(packet_start - codec.position + packet_length)
    end
  end
end
