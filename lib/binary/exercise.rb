require 'binary/packet'
require 'binary/type'

module Binary
  class Exercise < Binary::Packet
    PACKET_TYPE = Binary::Type::EXERCISE

    def initialize(packet_length)
      super(PACKET_TYPE, packet_length)
    end

    def to_h
        {
            master_exercise_id:          @master_exercise_id,
            owner_user_master_id:        @owner_user_master_id,
            original_master_exercise_id: @original_master_exercise_id,
            exercise_type:               @exercise_type,
            description:                 @description,
            flags:                       @flags,
            is_public:                   @is_public,
            is_deleted:                  @is_deleted,
            mets:                        @mets
        }
    end

    def set_default_values
        @master_exercise_id          = 0
        @owner_user_master_id        = 0
        @original_master_exercise_id = 0
        @exercise_type               = 0
        @description                 = ''
        @flags                       = 0
        @mets                        = 0
    end

    def read_body_from_codec(codec)
        @master_exercise_id          = codec.read_4_byte_int
        @owner_user_master_id        = codec.read_4_byte_int
        @original_master_exercise_id = codec.read_4_byte_int
        @exercise_type               = codec.read_2_byte_int
        @description                 = codec.read_string
        @flags                       = codec.read_4_byte_int
        @mets                        = codec.read_float
    end
  end
end
