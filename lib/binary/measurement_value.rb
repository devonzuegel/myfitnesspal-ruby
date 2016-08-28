require_relative 'packet'
require_relative 'type'

module MFP
  module Binary
    class MeasurementValue < Packet
      PACKET_TYPE = Type::MEASUREMENT_VALUE

      def initialize
        super(PACKET_TYPE)
      end

      def to_h
        super.merge(
          master_measurement_id: @master_measurement_id,
          type_name:             @type_name,
          entry_date:            @entry_date,
          value:                 @value
        )
      end

      def set_default_values
        @master_measurement_id = 0
        @type_name             = ''
        @entry_date            = DateTime.now
        @value                 = 0
      end

      def read_body_from_codec(codec)
        @master_measurement_id = codec.read_8_byte_int
        @type_name             = codec.read_string
        @entry_date            = codec.read_date
        @value                 = codec.read_float
      end
    end
  end
end
