require 'binary/packet'
require 'binary/type'

module MFP
  module Binary
    class ExerciseEntry < Packet
      PACKET_TYPE = Type::EXERCISE_ENTRY

      def initialize
        super(PACKET_TYPE)
      end

      def to_h
        super.merge(
          master_exercise_id: @master_exercise_id,
          exercise:           @exercise,
          date:               @date,
          quantity:           @quantity,
          sets:               @sets,
          weight:             @weight,
          calories:           @calories
        )
      end

      def set_default_values
        @master_exercise_id = 0
        @exercise           = Binary::Exercise.new
        @date               = DateTime.now
        @quantity           = 0
        @sets               = 0
        @weight             = 0
        @calories           = 0
      end

      def read_body_from_codec(codec)
        @master_exercise_entry_id = codec.read_8_byte_int
        @exercise                 = Binary::Exercise.new
        @exercise.read_body_from_codec(codec)

        @date     = codec.read_date
        @quantity = codec.read_4_byte_int
        @sets     = codec.read_4_byte_int
        @weight   = codec.read_4_byte_int
        @calories = codec.read_4_byte_int
      end
    end
  end
end
