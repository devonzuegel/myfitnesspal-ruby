require 'binary/packet'
require 'binary/type'
require 'binary/meal_ingredient'

module MFP
  module Binary
    class MealIngredients < Binary::Packet
      PACKET_TYPE = Binary::Type::MEAL_INGREDIENTS

      def initialize
        super(PACKET_TYPE)
      end

      def to_h
        super.merge(ingredients: @ingredients.map(&:to_h))
      end

      def set_default_values
        @ingredients = []
      end

      def read_body_from_codec(codec)
        @master_food_id = codec.read_4_byte_int
        @ingredients    = retrieve_ingredients(codec)
      end

      def retrieve_ingredients(codec)
        ingredient_count = codec.read_4_byte_int
        Array.new(ingredient_count) do
          ingredient = Binary::MealIngredient.new
          ingredient.read_body_from_codec(codec)
          ingredient
        end
      end
    end
  end
end
