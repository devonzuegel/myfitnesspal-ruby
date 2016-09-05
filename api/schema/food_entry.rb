module API
  module Schema
    module FoodEntry
      class Creation
        include Procto.call, Concord.new(:params)

        def call
          Result.new(dry_schema.messages, dry_schema.output)
        end

        private

        def dry_schema
          schema =
            Dry::Validation.Schema do
              required(:date).filled(:date_time?)
              required(:meal_name).filled(:str?)
              required(:quantity).filled(:float?)
              required(:serialized).filled(:str?, min_size?: 50)
              required(:portion_id).filled(:int?)
              required(:user_id).filled(:int?)
            end

          schema.call(params)
        end
      end
    end
  end
end
