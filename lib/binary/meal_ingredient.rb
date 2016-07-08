require 'binary/packet'

module Binary
  class MealIngredient < Binary::Packet
    def initialize
      set_default_values
    end

    def to_h
      {
        master_ingredient_id: @master_ingredient_id,
        master_food_id:       @master_food_id,
        fraction_int:         @fraction_int,
        is_fraction:          @is_fraction,
        quantity:             @quantity,
        weight_index:         @weight_index
      }
    end

    def set_default_values
      @master_ingredient_id = 0
      @master_food_id       = 0
      @fraction_int         = 0
      @is_fraction          = 0
      @quantity             = 0
      @weight_index         = 0
    end

    def read_body_from_codec(codec)
      @master_ingredient_id = codec.read_4_byte_int
      @master_food_id       = codec.read_4_byte_int
      @fraction_int         = codec.read_4_byte_int
      @quantity             = codec.read_float
      @weight_index         = codec.read_2_byte_int
    end
  end
end
