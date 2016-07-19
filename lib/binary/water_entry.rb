require 'binary/packet'
require 'binary/type'

module MFP
  module Binary
    class WaterEntry < Packet
      PACKET_TYPE = Type::WATER_ENTRY

      def initialize
        super(PACKET_TYPE)
      end

      def set_default_values; end

      def read_body_from_codec(codec); end
    end
  end
end
