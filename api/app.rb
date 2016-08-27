module API
  ROOT = Pathname.new('.').expand_path
  Dir.glob(ROOT.join('api', '**', '*.rb')) { |f| require f }
  Dir.glob(ROOT.join('lib', '**', '*.rb')) { |f| require f }

  module Models
    autoload :User, 'models/user'
  end

  class App < Routes::Base
    get '/favicon.ico' do
      send_file(ROOT.join('public', app_env.favicon))
    end

    use Routes::Users
  end
end
