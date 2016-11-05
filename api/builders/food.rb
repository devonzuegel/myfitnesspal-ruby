require_relative 'utils'
require_relative './base'
require_relative '../schema/food'
require_relative '../mappers/food'

module API
  module Builders
    class Food < Base
      VALIDATION_CLASS = Schema::Food::Creation
      MAPPER_CLASS     = Mappers::Food

      def initialize(params, repo)
        super(params.to_h, VALIDATION_CLASS, MAPPER_CLASS.new(repo))
      end

      def first_or_create
        conditions = { master_food_id: params.fetch(:master_food_id) }

        if mapper.available?(conditions)
          call
        else
          mapper.query(conditions).first.to_h
        end
      end

      private

      def transformed_params
        {
          master_food_id: params.fetch(:master_food_id),
          brand:          params.fetch(:brand),
          description:    params.fetch(:description),
          grams:          params.fetch(:grams),
          calories:       params.fetch(:nutrients).fetch(:calories),
          serialized:     YAML.dump(params)
        }
      end
    end
  end
end
