require_relative './base'

module API
  module Workers
    class BuildFoodEntry < Base
      include Sidekiq::Worker

      sidekiq_options retry: false

      def perform(hash_packet, user_id, repo_uri = nil)
        Builders::FoodOrchestrator.call(
          hash_packet,
          repo(repo_uri),
          user_id
        )
      end
    end
  end
end
