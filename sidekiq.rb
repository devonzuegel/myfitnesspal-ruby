Bundler.require
Dotenv.load '.env.development'

require './api/app'

SIDEKIQ_REPO = API::SqlRepo.new(ENV['DATABASE_URL'])