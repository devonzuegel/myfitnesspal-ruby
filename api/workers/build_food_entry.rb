module API
  module Workers
    class BuildFoodEntry
      include Sidekiq::Worker

      def perform(hash_packet, db_uri, user_id)
        Builders::FoodOrchestrator
          .call(hash_packet, SqlRepo.new(db_uri), user_id)
      end
    end
  end
end

module API
  module Workers
    class FetchPackets
      include Sidekiq::Worker

      def self.perform_async(*args)
        new.perform(*args)
      end

      def perform(username, password)
        MFP::Sync
          .new(username, password)
          .all_packets
      end
    end
  end
end

