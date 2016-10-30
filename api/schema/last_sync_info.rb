module API
  module Schema
    module LastSyncInfo
      class Creation
        include Procto.call, Concord.new(:params)

        def call
          Result.new(dry_schema.messages, dry_schema.output)
        end

        private

        def dry_schema
          schema =
            Dry::Validation.Schema do
              required(:deleted_item).value(:str?)
              required(:diary_note).value(:str?)
              required(:exercise).value(:str?)
              required(:exercise_entry).value(:str?)
              required(:food).value(:str?)
              required(:food_entry).value(:str?)
              required(:measurement).value(:str?)
              required(:user_property).value(:str?)
              required(:user_status).value(:str?)
              required(:water_entry).value(:str?)
            end

          schema.call(params)
        end
      end
    end
  end
end
