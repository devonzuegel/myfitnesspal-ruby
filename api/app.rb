module API
  ROOT = Pathname.new('.').expand_path
  Dir.glob(ROOT.join('lib', '**', '*.rb')) { |f| require f }
  Dir.glob(ROOT.join('api', '**', '*.rb')) { |f| require f }

  class App < Routes::Base
    get '/favicon.ico' do
      send_file(ROOT.join('public', app_env.favicon))
    end

    get '/sync' do
      user = Mappers::User.new(app_env.repository).query({}).first
      Workers::Sync.perform_async({
        'username' => user.username,
        'password' => user.password,
      }, user.id)
      json(messages: 'Beginning sync')
    end
  end
end
