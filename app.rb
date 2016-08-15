require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load

Dir.glob(Pathname.new('api').join('**', '*.rb').expand_path) { |f| require f }

module API
  module Models
    autoload :User, 'models/user'
  end

  class App < Sinatra::Application
    configure do
      disable :method_override
      disable :static

      set :sessions,
          httponly:     true,
          secure:       production?,
          expire_after: 31_557_600, # 1 year
          secret:       ENV['SESSION_SECRET']
    end

    use Rack::Deflater
    use Routes::Users
  end
end
