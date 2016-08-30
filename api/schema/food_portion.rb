module API
  module Schema
    module FoodPortion
      class Creation
        include Procto.call, Concord.new(:params)

        def call
          Result.new(dry_schema.messages, dry_schema.output)
        end

        private

        def dry_schema
          schema =
            Dry::Validation.Schema do
              required(:options_index).filled(:int?)
              required(:description).filled(:str?)
              required(:amount).filled(:float?)
              required(:gram_weight).filled(:float?)
              required(:serialized).filled(:str?, min_size?: 50)
              required(:food_id).filled(:int?)
            end

          schema.call(params)
        end
      end
    end
  end
end
