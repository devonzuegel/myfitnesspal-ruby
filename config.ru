require 'bundler/setup'

Bundler.require
Dotenv.load '.env.dev'

require './app'

env = { # Create as separate object
  db: Sequel.connect(ENV['DATABASE_CONNECTION'])
}

DB = env[:db]

run API::App.new(env)
