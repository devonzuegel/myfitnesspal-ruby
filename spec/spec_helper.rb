require_relative './support/db_context'
require_relative './support/mock_db_context'
require_relative './support/food_entry_packet_context'
require_relative './support/fixture_helpers'
require 'bundler/setup'
require 'sidekiq/testing'

Bundler.require(:default, :test)
Dotenv.load '.env.test'

require Pathname.new('.').join('api', 'app').expand_path

RSpec.configure do |c|
  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  c.filter_run focus: ENV['CI'] != 'true'
  c.run_all_when_everything_filtered = true

  c.before(:each) { Sidekiq::Worker.clear_all }


  WebMock.disable_net_connect!(allow_localhost: true)

  c.around(:each) { |t| Timeout.timeout(1, &t) }

  c.include_context 'db context', db: true
  c.include_context 'mock db context', mock_db: true
  c.include_context 'food entry packet', food_entry_packet: true

  c.include FixtureHelpers

  c.order = 'random'
end
