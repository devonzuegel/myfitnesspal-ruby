module API
  module Mappers
    class FoodEntry < ROM::Repository[:food_entries]
      commands :create

      def query(conditions)
        food_entries
          .where(conditions)
          .as(Models::FoodEntry)
          .to_ary
      end
    end
  end
end
