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

      def available?(conditions)
        food_portions
          .unique?(
            food_id:       conditions.fetch(:food_id),
            options_index: conditions.fetch(:options_index)
          )
      end
    end
  end
end
