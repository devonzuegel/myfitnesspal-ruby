Bundler.require
Dotenv.load '.env.development'

require './api/app'

environment =
  API::Env.new(
    repository: API::SqlRepo.new(ENV['DATABASE_URL']),
    rack_env:   ENV['RACK_ENV'],
    secret:     ENV['SESSION_SECRET'],
    favicon:    Pathname.new('.').expand_path.join('public', 'favicon-production.ico')
  )

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
   [user, password] == %w[u p]
end

run Rack::URLMap.new(
  '/'      => API::App.new(API::Env::Wrapper.new(environment)),
  '/admin' => Sidekiq::Web
)
