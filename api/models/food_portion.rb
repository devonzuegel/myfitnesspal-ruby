module API
  module Models
    class FoodPortion
      include Anima.new(
        :id,
        :options_index,
        :description,
        :amount,
        :gram_weight,
        :serialized,
        :food_id
      )
    end
  end
end
