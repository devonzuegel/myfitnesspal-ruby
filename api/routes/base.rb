require_relative '../utils'
module API
  module Routes
    class Base < Sinatra::Application
      include API::Utils

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
