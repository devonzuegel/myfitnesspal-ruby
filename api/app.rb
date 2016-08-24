Dir.glob(Pathname.new('.').join('api', '**', '*.rb').expand_path) { |f| require f }

module API
  require 'sinatra/base'

  module Models
    autoload :User, 'models/user'
  end

  class App < Sinatra::Application
    def initialize(environment)
      @environment = environment
      super
    end

    get '/' do
      ap environment.to_h
      'not implemented'
    end

    configure do
      disable :method_override
      disable :static

      set :environment, ENV['RACK_ENV'].to_sym

      set :sessions,
          httponly: true,
          secure:   production?,
          secret:   ENV['SESSION_SECRET']
    end

    use Rack::Deflater
    use Routes::Users

    private

    attr_reader :environment
  end
end