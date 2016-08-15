require 'bundler/setup'
Bundler.require

ENV['RACK_ENV'] = 'test'
DB = Sequel.connect('postgres://devonzuegel@localhost/mfp_api_test')

require Pathname.new('.').join('app').expand_path

RSpec.configure do |config|
  config.filter_run_excluding skip: true

  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  config.filter_run focus: ENV['CI'] != 'true'
  config.run_all_when_everything_filtered = true

  # Disable external requests
  WebMock.disable_net_connect!(allow_localhost: true)

  # Fail tests that run for longer than 1 seconds
  config.around(:each) { |test| Timeout.timeout(1, &test) }

  # Randomize order of specs
  config.order = 'random'
end
