require_relative './support/db_context'
require_relative './support/food_entry_packet_context'
require_relative './support/fixture_helpers'
require 'bundler/setup'

Bundler.require(:default, :test)
Dotenv.load '.env.test'

require Pathname.new('.').join('api', 'app').expand_path

RSpec.configure do |c|
  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  c.filter_run focus: ENV['CI'] != 'true'
  c.run_all_when_everything_filtered = true

  # Disable external requests
  WebMock.disable_net_connect!(allow_localhost: true)

  # Fail tests that run for longer than 1 seconds
  c.around(:each) { |t| Timeout.timeout(1, &t) }

  c.include_context 'db context', db: true
  c.include_context 'food entry packet', food_entry_packet: true

  c.include FixtureHelpers

  # Randomize order of specs
  c.order = 'random'
end
