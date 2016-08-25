require 'bundler/setup'

Bundler.require
Dotenv.load '.env.development'

require './api/app'

environment =
  API::Env.new(
    repository: API::SqlRepo.new(ENV['DATABASE_CONNECTION']),
    rack_env:   ENV['RACK_ENV'],
    secret:     ENV['SESSION_SECRET']
  )

ap environment.to_h

run API::App.new(API::Env::Wrapper.new(environment))
