module API
  module Models
    class Food
      include Anima.new(
        :id,
        :master_food_id,
        :description,
        :brand,
        :calories,
        :grams,
        :serialized
      )

      attr_reader :id
    end
  end
end
