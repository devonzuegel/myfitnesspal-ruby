require_relative 'base'

module API
  module Routes
    class Summary < Routes::Base
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

      get '/sync_all' do
        users = Mappers::User.new(app_env.repository).query({})

        users.each do |user|
          puts("Syncing #{user.username}'s data... [user ##{user.id}]".blue)
          Workers::Sync.perform_async({
            'username' => user.username,
            'password' => user.password,
          }, user.id)
        end

        json(messages: "Beginning sync for #{users.length} users...")
      end
    end
  end
end
