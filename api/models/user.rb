module API
  module Models
    class User
      def self.create
        # Raise error if user with given username is already in system
        # Create user with username, password
        # Start background job to sync user's history
      end
    end
  end
end
