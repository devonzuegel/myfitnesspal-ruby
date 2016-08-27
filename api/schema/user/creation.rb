module API
  module Schema
    module User
      class Creation
        include Procto.call, Concord.new(:params, :repository)

        def call
          Schema::Result.new(messages, dry_schema.output)
        end

        private

        def messages
          if dry_schema.success?
            username_availability
          else
            dry_schema.messages
          end
        end

        def username_availability
          return {} if repository.available?(params)
          { username: ['has already been taken'] }
        end

        def dry_schema
          schema =
            Dry::Validation.Schema do
              required(:username).filled(:str?, size?: 4..30)
              required(:password).filled(:str?, size?: 6..255)
            end

          schema.call(params)
        end
      end
    end
  end
end
