require_relative 'utils'
require_relative '../schema/last_sync_info'
require_relative '../mappers/last_sync_info'

module API
  module Builders
    class LastSyncInfo < Base
      VALIDATION_CLASS = Schema::LastSyncInfo::Creation
      MAPPER_CLASS     = Mappers::LastSyncInfo

      def initialize(params, repo)
        @date = params[:date]
        super(params, VALIDATION_CLASS, MAPPER_CLASS.new(repo))
      end

      def call
        if validation_result.success?
          super().merge(date: date)
        else
          super()
        end
      end

      private

      attr_reader :date

      def validation_result
        result = validation.call(*validation_arguments)
        output =
          result.output
            .merge(serialized_ptrs: result.output[:ptrs].to_s)
            .reject { |k, v| k == :ptrs }
        Schema::Result.new(result.messages, output)
      end
      memoize :validation_result

      def transformed_params
        return params if date.nil?
        params.merge(date: date) # Keep date as DateTime rather than JSON string
      end
    end
  end
end
