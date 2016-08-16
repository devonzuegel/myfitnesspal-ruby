require 'bundler/setup'

Bundler.require
Dotenv.load '.env.dev'

require './app'

db = Sequel.connect(ENV['DATABASE_CONNECTION'])
DB = Sequel.connect(ENV['DATABASE_CONNECTION'])

run API::App.new(db)
