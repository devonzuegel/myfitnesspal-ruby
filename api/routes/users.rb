require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/create' do
        result = Services::UserSignup.call(params, app_env.repository)

        json(result)
      end

      get '/' do
        users          = Mappers::User.new(app_env.repository).query({}).map(&:to_h)
        foods          = Mappers::Food.new(app_env.repository).query({}).map(&:to_h)
        food_entries   = Mappers::FoodEntry.new(app_env.repository).query({}).map(&:to_h)
        food_portions  = Mappers::FoodPortion.new(app_env.repository).query({}).map(&:to_h)
        last_sync_info = Mappers::LastSyncInfo.new(app_env.repository).query({}).map(&:to_h)

        json(
          users:          users.length,
          foods:          foods.length,
          food_entries:   food_entries.length,
          food_portions:  food_portions.length,
          last_sync_info: last_sync_info.length,
        )
      end
    end
  end
end
