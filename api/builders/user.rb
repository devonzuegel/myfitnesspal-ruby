require_relative 'utils'
require_relative '../schema/user/creation'
require_relative '../mappers/user'

module API
  module Builders
    class User < Base
      VALIDATION_CLASS = Schema::User::Creation
      MAPPER_CLASS     = Mappers::User

      def initialize(params, repo)
        super(params, VALIDATION_CLASS, MAPPER_CLASS.new(repo))
      end

      private

      def validation_arguments
        super << mapper
      end
    end
  end
end
