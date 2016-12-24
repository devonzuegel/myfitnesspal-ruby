require_relative 'utils'
require_relative './base'
require_relative '../schema/food_entry'
require_relative '../mappers/food_entry'

module API
  module Builders
    class FoodEntry < Base
      VALIDATION_CLASS = Schema::FoodEntry::Creation
      MAPPER_CLASS     = Mappers::FoodEntry

      def initialize(params, portion_id, user_id, repo)
        super(
          consolidated_params(params, portion_id, user_id),
          VALIDATION_CLASS,
          MAPPER_CLASS.new(repo)
        )
      end

      private

      def transformed_params
        {
          date:       DateTime.parse(params.fetch(:date)),
          meal_name:  params.fetch(:meal_name),
          quantity:   params.fetch(:quantity),
          user_id:    params.fetch(:user_id),
          portion_id: params.fetch(:portion_id)
        }
      end

      def consolidated_params(params, portion_id, user_id)
        params.to_h.merge(
          user_id:    user_id,
          portion_id: portion_id
        )
      end
    end
  end
end
