require_relative 'utils'

module API
  module Builders
    class Base
      include Utils, Procto.call, Concord.new(:params, :validation, :mapper), Memoizable

      def initialize(params, validation, mapper)
        super(symbolize_keys(params), validation, mapper)
      end

      def call
        if validation_result.success?
          mapper.create(validation_result.output).to_h
        else
          { errors: validation_result.messages }
        end
      end

      private

      def validation_result
        validation.call(*validation_arguments)
      end
      memoize :validation_result

      def validation_arguments
        [transformed_params]
      end

      def transformed_params
        params
      end
    end
  end
end
