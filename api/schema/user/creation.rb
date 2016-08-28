module API
  module Schema
    module User
      class Creation
        include Procto.call, Concord.new(:credentials, :repository)

        def call
          return dry_schema unless dry_schema.success?
          mfp_auth = MFPAuth.call(credentials, repository, MFP::Credentials)
          dry_schema << mfp_auth
        end

        private

        def dry_schema
          schema =
            Dry::Validation.Schema do
              required(:username).filled(:str?, size?: 4..30)
              required(:password).filled(:str?, size?: 6..255)
            end

          result = schema.call(credentials)
          Result.new(result.messages, result.output)
        end
      end
    end
  end
end
