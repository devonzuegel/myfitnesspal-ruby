require 'bundler/setup'

Bundler.require
Dotenv.load '.env.development'

require './api/app'

environment =
  API::Env.new(
    repository: API::SqlRepo.new(ENV['DATABASE_URL']),
    rack_env:   ENV['RACK_ENV'],
    secret:     ENV['SESSION_SECRET']
  )

run API::App.new(API::Env::Wrapper.new(environment))
