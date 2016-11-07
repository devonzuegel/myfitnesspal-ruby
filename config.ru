Bundler.require
Dotenv.load '.env.development'

ROOT = Pathname.new('.').expand_path
Dir.glob(ROOT.join('lib', '**', '*.rb')) { |f| require f }
Dir.glob(ROOT.join('api', '**', '*.rb')) { |f| require f }

environment =
  API::Env.new(
    repository: API::SqlRepo.new(ENV['DATABASE_URL']),
    rack_env:   ENV['RACK_ENV'],
    secret:     ENV['SESSION_SECRET'],
    favicon:    Pathname.new('.').expand_path.join('public', 'favicon-production.ico')
  )

Sidekiq::Web.set :session_secret, environment.secret

map '/users' do
  run API::Routes::Users.new(API::Env::Wrapper.new(environment))
end

map '/entries' do
  run API::Routes::Entries.new(API::Env::Wrapper.new(environment))
end

map '/admin' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    # Protect against timing attacks: (https://codahale.com/a-lesson-in-timing-attacks/)
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    Rack::Utils.secure_compare(
      ::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])
    ) & Rack::Utils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
    )
  end

  run Sidekiq::Web
end
