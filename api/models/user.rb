module API
  module Models
    class User
      include Anima.new(:id, :username, :password)
    end
  end
end
