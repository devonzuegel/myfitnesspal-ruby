module API
  module Mappers
    class FoodPortion < ROM::Repository[:food_portions]
      commands :create

      def query(conditions)
        food_portions
          .where(conditions)
          .as(Models::FoodPortion)
          .to_ary
      end
    end
  end
end
