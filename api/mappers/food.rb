module API
  module Mappers
    class Food < ROM::Repository[:food]
      commands :create

      def query(conditions)
        food.where(conditions).as(Models::Food).to_ary
      end
    end
  end
end
