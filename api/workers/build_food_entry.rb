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

