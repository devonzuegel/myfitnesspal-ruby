require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/users/create' do
        result = Services::UserSignup.call(params, app_env.repository)

        json(result)
      end

      get '/users' do
        foods         = Mappers::Food.new(app_env.repository).query({}).map(&:to_h)
        food_entries  = Mappers::FoodEntry.new(app_env.repository).query({}).map(&:to_h)
        food_portions = Mappers::FoodPortion.new(app_env.repository).query({}).map(&:to_h)

        json(
          users: Mappers::User.new(app_env.repository).query({}).map(&:to_h),
          counts: {
            foods:         foods.length,
            food_entries:  food_entries.length,
            food_portions: food_portions.length,
          },
        )
      end

      get '/sync' do
        user = Mappers::User.new(app_env.repository).query({}).first
        Workers::Sync.perform_async({
          'username' => user.username,
          'password' => user.password,
        }, user.id)
        json(messages: 'Beginning sync')
      end
    end
  end
end
