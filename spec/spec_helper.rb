require 'bundler/setup'
Bundler.require(:default, :test)
Dotenv.load '.env.test'

ENV['RACK_ENV'] = 'test'
db = Sequel.connect(ENV['DATABASE_CONNECTION'])
DB = db

require Pathname.new('.').join('app').expand_path

RSpec.configure do |c|
  # Tag examples with `:focus` to run them individually. When
  # nothing is tagged with `:focus`, all examples get run.
  c.filter_run focus: ENV['CI'] != 'true'
  c.run_all_when_everything_filtered = true

  # Disable external requests
  WebMock.disable_net_connect!(allow_localhost: true)

  # Fail tests that run for longer than 1 seconds
  c.around(:each) { |t| Timeout.timeout(1, &t) }

  # Rollback db transactions after each test that requires the db
  c.around(:each) do |t|
    if t.metadata[:db]
      DB.transaction(rollback: :always, auto_savepoint: true) { t.run }
    else
      t.run
    end
  end

  # Randomize order of specs
  c.order = 'random'
end
