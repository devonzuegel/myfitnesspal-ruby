module API
  module Routes
    class Base < Sinatra::Application
      def initialize(environment)
        @environment = environment
        super
      end

      private

      attr_reader :environment

      def symbolize_keys(myhash)
        myhash.keys.each do |key|
          myhash[key.to_sym] = myhash.delete(key)
        end
      end

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
