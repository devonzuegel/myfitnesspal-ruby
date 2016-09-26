require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/users/create' do
        result = Services::UserSignup.call(params, app_env.repository)

        json(result)
      end

      get '/users' do
        json(
          users: Mappers::User.new(app_env.repository).query({}).map(&:to_h),
          foods: Mappers::Food.new(app_env.repository).query({}).map(&:to_h)
        )
      end
    end
  end
end
