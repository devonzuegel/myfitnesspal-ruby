require_relative 'utils'
require_relative '../schema/food'
require_relative '../mappers/food'

module API
  module Builders
    class Food < Base
      VALIDATION_CLASS = Schema::Food::Creation
      MAPPER_CLASS     = Mappers::Food

      def initialize(params, repo)
        super(params, VALIDATION_CLASS, MAPPER_CLASS.new(repo))
      end
    end
  end
end
