require 'bundler/setup'
Bundler.require

ENV['RACK_ENV'] = 'test'
DB = Sequel.connect('postgres://devonzuegel@localhost/mfp_api_test')

require Pathname.new('.').join('app').expand_path

RSpec.configure do |c|
  c.filter_run_excluding skip: true

  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  c.filter_run focus: ENV['CI'] != 'true'
  c.run_all_when_everything_filtered = true

  # Disable external requests
  WebMock.disable_net_connect!(allow_localhost: true)

  # Fail tests that run for longer than 1 seconds
  c.around(:each) { |t| Timeout.timeout(1, &t) }

  # Rollback db transactions after each test
  c.around(:each) { |t| DB.transaction(rollback: :always, auto_savepoint: true) { t.run } }

  # Randomize order of specs
  c.order = 'random'
end
