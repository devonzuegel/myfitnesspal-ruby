module API
  module Mappers
    class FoodPortion < ROM::Repository[:food_portion]
      commands :create

      def query(conditions)
        food_portion
          .where(conditions)
          .as(Models::FoodPortion)
          .to_ary
      end
    end
  end
end
