require 'binary/packet'
require 'binary/type'

module Binary
  class MeasurementTypes < Binary::Packet
    PACKET_TYPE = Binary::Type::MEASUREMENT_TYPES

    def initialize(packet_length)
      super(PACKET_TYPE, packet_length)
    end

    def to_json
      super.merge(descriptions: @descriptions)
    end

    def set_default_values
        @descriptions = {}
    end

    def read_body_from_codec(codec)
        @descriptions = codec.read_map(
          read_key: -> { codec.read_4_byte_int }
        )
    end
  end
end
