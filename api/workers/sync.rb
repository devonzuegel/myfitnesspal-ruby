module API
  module Workers
    class Sync < Base
      include Sidekiq::Worker

      def perform(params, user_id, repo_uri = nil)
        # TODO retrieve user's most recent last_sync_ptrs to pass to MFP::Sync

        sync = MFP::Sync.new(
          params.fetch('username'),
          params.fetch('password')
        )

        packets = sync.all_packets

        Builders::LastSyncInfo.call({
          user_id: user_id,
          date:    DateTime.now,
          ptrs:    sync.last_sync_pointers,
        }, repo(repo_uri))

        Builders::Sync.call(
          packets.reverse,
          user_id,
          repo(repo_uri)
        )
      end
    end
  end
end

