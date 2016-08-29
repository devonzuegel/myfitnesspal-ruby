require_relative 'utils'

module API
  module Builders
    class User
      include Utils, Procto.call, Concord.new(:params, :validation, :mapper), Memoizable

      def call
        return error_messages unless validation_result.success?

        mapper.create(validation_result.output)
        validation_result.output
      end

      private

      def validation_result
        validation.call(symbolize_keys(params), mapper)
      end
      memoize :validation_result

      def error_messages
        {
          errors: validation_result.messages
        }
      end
    end
  end
end
