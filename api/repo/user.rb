module API
  module Repo
    class User < ROM::Repository[:users]
      commands :create

      def query(conditions)
        users.where(conditions).as(Models::User).to_ary
      end

      def available?(conditions)
        users.unique?(username: conditions.fetch(:username))
      end
    end
  end
end
