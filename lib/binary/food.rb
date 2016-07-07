require 'binary/packet'
require 'binary/type'
require 'binary/food_portion'

module Binary
  class Food < Binary::Packet
    PACKET_TYPE = Binary::Type::FOOD

    NUTRIENT_NAMES = %w(
      calories fat saturated_fat polyunsaturated_fat monounsaturated_fat trans_fat cholesterol
      sodium potassium carbohydrates fiber sugar protein vitamin_a vitamin_c calcium iron
    )

    def initialize(packet_length)
      super(PACKET_TYPE, packet_length)
    end

    def to_json
      super.merge(
        master_food_id:       @master_food_id,
        owner_user_master_id: @owner_user_master_id,
        original_master_id:   @original_master_id,
        description:          @description,
        brand:                @brand,
        flags:                @flags,
        is_public:            @is_public,
        is_deleted:           @is_deleted,
        nutrients:            @nutrients,
        grams:                @grams,
        type:                 @type,
        is_meal:              @is_meal,
        portions:             @portions.map(&:to_json)
      )
    end

    def set_default_values
      @master_food_id       = 0
      @owner_user_master_id = 0
      @original_master_id   = 0
      @description          = ''
      @brand                = ''
      @flags                = 0
      @nutrients            = {}
      @grams                = 0
      @type                 = 0
      @portions             = []
    end

    def read_body_from_codec(codec)
      @master_food_id       = codec.read_4_byte_int
      @owner_user_master_id = codec.read_4_byte_int
      @original_master_id   = codec.read_4_byte_int
      @description          = codec.read_string
      @brand                = codec.read_string
      @flags                = codec.read_4_byte_int
      @nutrients            = retrieve_nutrients(codec)
      @grams                = codec.read_float
      @type                 = codec.read_2_byte_int
      @portions             = retrieve_portions(codec)
    end

    def retrieve_nutrients(codec)
      NUTRIENT_NAMES.each do |nutrient|
        @nutrients[nutrient] = codec.read_float
      end
      @nutrients
    end

    def retrieve_portions(codec)
      num_portions = codec.read_2_byte_int
      @portions = num_portions.times.map do
        food_portion = Binary::FoodPortion.new
        food_portion.read_body_from_codec(codec)
        food_portion
      end
    end
  end
end
