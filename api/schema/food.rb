module API
  module Schema
    module Food
      class Creation
        include Procto.call, Concord.new(:params)

        def call
          Result.new(dry_schema.messages, dry_schema.output)
        end

        private

        def dry_schema
          schema =
            Dry::Validation.Schema do
              required(:master_food_id).filled(:int?)
              required(:description).filled(:str?)
              required(:brand).value(:str?)
              required(:calories).filled(:float?)
              required(:grams).filled(:float?)
              required(:serialized).filled(:str?, min_size?: 50)
            end

          schema.call(params)
        end
      end
    end
  end
end
