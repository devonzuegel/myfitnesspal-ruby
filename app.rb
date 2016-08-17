Dir.glob(Pathname.new('.').join('api', '**', '*.rb').expand_path) { |f| require f }

module API
  module Models
    autoload :User, 'models/user'
  end

  class App < Sinatra::Application
    def initialize(db)
      @db = db
      super
    end

    configure do
      disable :method_override
      disable :static

      set :environment, ENV['RACK_ENV'].to_sym

      set :sessions,
          httponly:     true,
          secure:       production?,
          expire_after: 31_557_600, # 1 year
          secret:       ENV['SESSION_SECRET']
    end

    use Rack::Deflater
    use Routes::Users

    private

    attr_reader :db
  end
end
