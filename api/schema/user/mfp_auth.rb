module API
  module Schema
    module User
      class MFPAuth
        include Procto.call, Concord.new(:username, :password)

        def call
          if authenticated?
            Schema::Result.new({}, {})
          else
            Schema::Result.new({ credentials: 'Incorrect username or password' }, {})
          end
        end

        private

        def authenticated?
          true
        end
      end
    end
  end
end
