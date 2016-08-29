require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/users/create' do
        result =
          Builders::User.call(
            params,
            Schema::User::Creation,
            Mappers::User.new(app_env.repository)
          )

        json(result)
      end
    end
  end
end
