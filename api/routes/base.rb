module API
  module Routes
    class Base < Sinatra::Application
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
