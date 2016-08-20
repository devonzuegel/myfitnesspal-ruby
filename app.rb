Dir.glob(Pathname.new('.').join('api', '**', '*.rb').expand_path) { |f| require f }

module API
  module Models
    autoload :User, 'models/user'
  end

  class App < Sinatra::Application
    def initialize(environment)
      ap environment
      @environment = environment
      super
    end

    def self.registered(app)
      ap app
      puts '-------------------'.yellow
      puts '-------------------'.yellow
      puts '-------------------'.yellow
      puts '-------------------'.yellow
      puts '-------------------'.yellow
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

    # private

    # attr_reader :environment
  end
end
