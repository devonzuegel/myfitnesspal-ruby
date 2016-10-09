module API
  module Services
    class UserSignup
      include Procto.call, Concord.new(:params, :repo), Memoizable, Builders::Utils

      def initialize(params, repo)
        super(symbolize_keys(params), repo)
      end

      def call
        unless built_user.key?(:errors)
          Workers::Sync.perform_async(params, repo, built_user.fetch(:id))
        end
        built_user
      end

      private

      def built_user
        Builders::User.call(params, repo)
      end
      memoize :built_user
    end
  end
end
