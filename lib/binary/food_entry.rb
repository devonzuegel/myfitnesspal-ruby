require 'binary/packet'
require 'binary/type'

module Binary
  class FoodEntry < Binary::Packet
    PACKET_TYPE = Binary::Type::FOOD_ENTRY

    def initialize(packet_length)
      super(PACKET_TYPE, packet_length)
    end

    def to_h
      super.merge(
        master_food_id: @master_food_id,
        food:           @food.to_h,
        date:           @date.iso8601,
        meal_name:      @meal_name,
        quantity:       @quantity,
        weight_index:   @weight_index
      )
    end

    def set_default_values
      @master_food_id = 0
      @food           = nil
      @date           = DateTime.now
      @meal_name      = ''
      @quantity       = 0
      @weight_index   = 0
    end

    def read_body_from_codec(codec)
      @master_food_id = codec.read_8_byte_int

      @food           = Binary::Food.new(nil)
      @food.read_body_from_codec(codec)

      @date           = codec.read_date
      @meal_name      = codec.read_string
      @quantity       = codec.read_float
      @weight_index   = codec.read_4_byte_int
    end
  end
end
