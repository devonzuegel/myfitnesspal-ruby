module API
  module Mappers
    class Food < ROM::Repository[:foods]
      commands :create

      def initialize(args)
        super(args)
      end

      def query(conditions)
        foods
          .where(conditions)
          .as(Models::Food)
          .to_ary
      end

      def available?(conditions)
        foods
          .unique?(master_food_id: conditions.fetch(:master_food_id))
      end
    end
  end
end
