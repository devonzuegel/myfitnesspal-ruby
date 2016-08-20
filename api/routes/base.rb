module API
  module Routes
    class Base < Sinatra::Application
      # def self.registered(app)
      #   puts '-------------------'.yellow
      #   puts '-------------------'.yellow
      #   puts '-------------------'.yellow
      #   puts '-------------------'.yellow
      #   puts '-------------------'.yellow
      # end

      # private

      def symbolize_keys(myhash)
        myhash.keys.each do |key|
          myhash[(key.to_sym rescue key) || key] = myhash.delete(key)
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
