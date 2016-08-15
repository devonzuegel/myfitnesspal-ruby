require 'bundler/setup'

Bundler.require
Dotenv.load

DB = Sequel.connect('postgres://devonzuegel@localhost/mfp_api_development')

require './app'
run API::App
