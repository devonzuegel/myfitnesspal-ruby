Bundler.require
Dotenv.load '.env.development'

require './api/app'

REPO = API::SqlRepo.new(ENV['DATABASE_URL'])