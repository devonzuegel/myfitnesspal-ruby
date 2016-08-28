require_relative 'packet'
require_relative 'type'

module MFP
  module Binary
    class UserPropertyUpdate < Binary::Packet
      PACKET_TYPE = Binary::Type::USER_PROPERTY_UPDATE

      def initialize
        super(PACKET_TYPE)
      end

      def to_h
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
end
