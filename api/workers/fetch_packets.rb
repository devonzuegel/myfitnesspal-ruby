module API
  module Workers
    class FetchPackets
      include Sidekiq::Worker

      def perform(username, password)
        MFP::Sync
          .new(username, password)
          .all_packets
      end
    end
  end
end
