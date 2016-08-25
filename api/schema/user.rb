module API
  module Schema
    module User
      class Creation
        include Procto.call, Concord.new(:params, :repository)

        def call
          dry = schema.call(params)
          return dry unless dry.success?
          Schema::Result.new(username_availability, dry.output)
        end

        private

        def username_availability
          return {} if repository.available?(params)
          { username: ['has already been taken'] }
        end

        def schema
          Dry::Validation.Schema do
            required(:username).filled(:str?, size?: 4..30)
            required(:password).filled(:str?, size?: 6..255)
          end
        end
      end
    end
  end
end
