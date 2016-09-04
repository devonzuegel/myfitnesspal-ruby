require_relative 'utils'

module API
  module Builders
    class Base
      include Utils, Procto.call, Concord.new(:params, :validation, :mapper), Memoizable

      def call
        return error_messages unless validation_result.success?

        mapper.create(validation_result.output)
        validation_result.output
      end

      private

      def validation_result
        validation.call(*validation_arguments)
      end
      memoize :validation_result

      def error_messages
        {
          errors: validation_result.messages
        }
      end

      def validation_arguments
        [symbolize_keys(params)]
      end
    end
  end
end
