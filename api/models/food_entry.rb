module API
  module Models
    class FoodEntry
      include Anima.new(
        :id,
        :date,
        :meal_name,
        :quantity,
        :serialized,
        :food_portion_id,
        :user_id
      )
    end
  end
end
