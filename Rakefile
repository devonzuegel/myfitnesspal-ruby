require 'bundler/setup'
Bundler.require

env_file = Pathname.new(ENV.fetch('ENV_FILE', '.env.development'))
if env_file.exist?
  puts "Loading environment from #{env_file}...".gray
  Dotenv.load(env_file)
else
  puts "WARNING: #{env_file} does not exist. Continuing without loading it into environment.".yellow
end

namespace :db do
  require_relative 'db/setup'
  db_connection_str = ENV.fetch('DATABASE_URL')
  db_name           = ENV.fetch('DATABASE_NAME')  # = db_connection_str.split('/').last

  task :setup, [:version] do |_, args|
    puts "Setting up database... [#{db_name}]".gray
    DB::Setup.call(db_connection_str, args.fetch(:version, nil))
  end

  task :clean do # Equivalent to `rake db:setup[0]`
    puts "Resetting database... [#{db_name}]".gray
    DB::Setup.call(db_connection_str, 0)
  end

  task :create do
    puts "Creating database... [#{db_name}]".gray
    pg_connection = PG.connect(db_connection_str)
    pg_connection.exec("CREATE DATABASE #{db_name}")
  end

  desc 'Dump the current schema to db/schema.sql'
  task :dump do
    sh(%Q( pg_dump --no-owner --schema-only --file "db/schema.sql" #{db_name}))
  end

  task :drop do
    fail ArgumentError, "You may not drop #{db_name}" unless db_name =~ /^mfp\_api_.*/

    puts "Dropping database... [#{db_name}]".gray
    pg_connection = PG.connect(db_connection_str)
    pg_connection.exec("DROP DATABASE #{db_name}")
  end
end
