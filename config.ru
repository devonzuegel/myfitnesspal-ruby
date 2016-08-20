require 'bundler/setup'

Bundler.require
Dotenv.load '.env.development'

require './app'

environment =
  API::Env.new(
    repository: API::SqlRepo.new(ENV['DATABASE_CONNECTION'])
  )

run API::App.new(environment)
