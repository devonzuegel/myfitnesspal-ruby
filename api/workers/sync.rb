module API
  module Workers
    class Sync < Base
      include Sidekiq::Worker

      def perform(params, user_id, repo_uri = nil)
        sync = MFP::Sync.new(params.fetch('username'), params.fetch('password'))

        Builders::Sync.call(sync.all_packets.reverse, user_id, repo(repo_uri))

        # ap sync.last_sync_pointers
      end
    end
  end
end

