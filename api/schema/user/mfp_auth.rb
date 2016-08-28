module API
  module Schema
    module User
      class MFPAuth
        include Procto.call, Concord.new(:credentials, :repository, :credentials_checker)

        def call
          Schema::Result.new(messages, {})
        end

        private

        USERNAME_TAKEN_MSG = { username: ['has already been taken'] }.freeze
        private_constant(:USERNAME_TAKEN_MSG)

        def messages
          if repository.available?(credentials)
            authentication_msgs
          else
            USERNAME_TAKEN_MSG
          end
        end

        def authentication_msgs
          credentials_checker
            .new(credentials.fetch(:username), credentials.fetch(:password), HTTP)
            .messages
        end
      end
    end
  end
end
