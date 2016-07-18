require 'bundler/setup'
require 'rspec'

RSpec.configure do |config|
  config.filter_run_excluding skip: true

  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  config.filter_run focus: ENV['CI'] != 'true'
  config.run_all_when_everything_filtered = true

  config.around(:each) do |test|
    Timeout.timeout(1, &test)
  end
end
