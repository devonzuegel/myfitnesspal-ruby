require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/create' do
        result = Services::UserSignup.call(params, app_env.repository)

        json(result)
      end

      get '/' do
        users =
          Mappers::User
            .new(app_env.repository)
            .query({})
            .map { |u| u.to_h.select { |k, v| %i[id username].include?(k) } }

        json(users)
      end
    end
  end
end
