module API
  module Services
    class UserSignup
      include Procto.call, Concord.new(:params, :repo), Memoizable

      def call
        unless built_user.key?(:errors)
          Builders::Sync.call(packets, repo, built_user.fetch(:id))
        end
        built_user
      end

      private

      def packets
        MFP::Sync
          .new(params.fetch(:username), params.fetch(:password))
          .all_packets
      end
      memoize :packets

      def built_user
        Builders::User.call(params, repo)
      end
      memoize :built_user
    end
  end
end
