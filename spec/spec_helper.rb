require 'bundler/setup'
require 'rspec'
require 'awesome_print'
require 'colorize'
require 'webmock/rspec'

require_relative '../app'
# Dir.glob(Pathname.new('..').join('api', '**', '*.rb').expand_path) { |f| require f }

RSpec.configure do |config|
  config.filter_run_excluding skip: true

  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  config.filter_run focus: ENV['CI'] != 'true'
  config.run_all_when_everything_filtered = true

  WebMock.disable_net_connect!(allow_localhost: true)

  config.around(:each) do |test|
    Timeout.timeout(320, &test)
  end
end
