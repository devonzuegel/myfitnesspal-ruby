module API
  module Models
    class User
      include Anima.new(:id, :username, :password)

      # Start background job to sync user's history
    end
  end
end
