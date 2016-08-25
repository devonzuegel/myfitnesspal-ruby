Dir.glob(Pathname.new('.').join('api', '**', '*.rb').expand_path) { |f| require f }

module API
  module Models
    autoload :User, 'models/user'
  end

  class App < Routes::Base
    get '/favicon.ico' do
    end

    use Routes::Users
  end
end
