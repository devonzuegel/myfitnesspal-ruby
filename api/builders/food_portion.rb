require_relative 'utils'
require_relative '../schema/food_portion'
require_relative '../mappers/food_portion'

module API
  module Builders
    class FoodPortion < Base
      VALIDATION_CLASS = Schema::FoodPortion::Creation
      MAPPER_CLASS     = Mappers::FoodPortion

      def initialize(params, options_index, food_id, repo)
        super(
          consolidated_params(params, options_index, food_id),
          VALIDATION_CLASS,
          MAPPER_CLASS.new(repo)
        )
      end

      private

      def transformed_params
        params
          .merge(serialized: YAML.dump(params))
          .reject { |k| %i[fraction_int is_fraction].include?(k) }
      end

      def consolidated_params(params, options_index, food_id)
        params
          .to_h
          .merge(options_index: options_index, food_id: food_id)
      end
    end
  end
end
