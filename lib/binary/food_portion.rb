require 'binary/packet'

module Binary
  class FoodPortion < Binary::Packet
    def initialize
      set_default_values
    end

    def to_json
      {
        amount:       @amount,
        gram_weight:  @gram_weight,
        description:  @description,
        fraction_int: @fraction_int,
        is_fraction:  @is_fraction
      }
    end

    def set_default_values
      @amount      = 0
      @gram_weight = 0
      @description = ''
      @is_fraction = 0
    end

    def read_body_from_codec(codec)
      @amount       = codec.read_float
      @gram_weight  = codec.read_float
      @description  = codec.read_string
      @fraction_int = codec.read_2_byte_int
    end
  end
end
