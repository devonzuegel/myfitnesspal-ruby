require 'binary/packet'
require 'binary/type'

module Binary
  class UserPropertyUpdate < Binary::Packet
    PACKET_TYPE = Binary::Type::USER_PROPERTY_UPDATE

    def initialize(packet_length)
      super(PACKET_TYPE, packet_length)
    end

    def to_json
      super.merge(properties: @properties)
    end

    def set_default_values
      @properties = {}
    end

    def read_body_from_codec(codec)
        @properties = codec.read_map(
          read_key: -> { codec.read_string }
        )
    end
  end
end
