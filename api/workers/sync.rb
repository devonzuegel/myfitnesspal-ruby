module API
  module Workers
    class Sync
      include Sidekiq::Worker

      def perform(params, repo, user_id)
        packets = get_packets(params)
        Builders::Sync.call(packets, repo, user_id)
      end

      private

      def get_packets(params)
        Workers::FetchPackets.perform_async(
          params.fetch('username'),
          params.fetch('password')
        )
      end
    end
  end
end

