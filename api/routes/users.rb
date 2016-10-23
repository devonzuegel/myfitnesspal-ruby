require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/users/create' do
        result = Services::UserSignup.call(params, app_env.repository)

        json(result)
      end

      get '/users/sync' do
        Workers::FetchPackets.perform_async(
          params.fetch('username'),
          params.fetch('password')
        )
        json(messages: 'Beginning sync')
      end

      get '/users' do
        json(
          users: Mappers::User.new(app_env.repository).query({}).map(&:to_h),
          foods: Mappers::Food.new(app_env.repository).query({}).map(&:to_h)
        )
      end

      get '/sync' do
        user = Mappers::User.new(app_env.repository).query({}).first
        Workers::Sync.perform_async({
          'username' => user.username,
          'password' => user.password,
        }, user.id)
        json('Syncing')
      end
    end
  end
end
