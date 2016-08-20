module API
  module Repo
    class User < ROM::Repository[:users]
      commands :create

      def query(conditions)
        users.where(conditions).as(API::Models::User).to_a
      end
    end
  end
end
