module API
  module Models
    class User < Sequel::Model
      plugin :validation_helpers

      def validate
        super
        validates_presence %i[username password]
        validates_unique :username
      end
      # Raise error if user with given username is already in system
      # Create user with username, password
      # Start background job to sync user's history
    end
  end
end
