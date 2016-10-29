module API
  module Workers
    class Sync < Base
      include Sidekiq::Worker

      def perform(params, user_id, repo_uri = nil)
        Builders::Sync.call(get_packets(params).reverse, user_id, repo(repo_uri))
      end

      private

      def get_packets(params)
        MFP::Sync
          .new(params.fetch('username'), params.fetch('password'))
          .all_packets
      end
    end
  end
end

