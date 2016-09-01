module API
  module Mappers
    class Food < ROM::Repository[:foods]
      commands :create

      def query(conditions)
        foods
          .where(conditions)
          .as(Models::Food)
          .to_ary
      end
    end
  end
end
