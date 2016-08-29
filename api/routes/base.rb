module API
  module Routes
    class Base < Sinatra::Application
      set :raise_errors, true
      set :show_exceptions, false

      def initialize(env_wrapper)
        @app_env = env_wrapper.app_env
        super
      end

      attr_reader :app_env

      private

      def json(data)
        Rack::Response.new(
          data.to_json,
          500,
          'Content-type' => 'application/json'
        ).finish
      end
    end
  end
end
