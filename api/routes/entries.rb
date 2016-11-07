require_relative 'base'

module API
  module Routes
    class Entries < Routes::Base
      get '/' do
        json(
          params: request.params,
          date:   DateTime.now.to_json
        )
      end

      get '/today' do
        repo         = app_env.repository
        food_entries = Mappers::FoodEntry.new(repo).query(date: Date.today)

        data =
          food_entries.map do |entry|
            portion = Mappers::FoodPortion.new(repo).query(id: entry.portion_id).first
            food    = Mappers::Food.new(repo).query(id: portion.food_id).first

            # {
              # entry:   entry.to_h,
              # portion: portion.to_h,
              # food:    food.to_h,
            # }
            YAML.load(entry.serialized)
          end

        json(data.uniq)
      end
    end
  end
end
