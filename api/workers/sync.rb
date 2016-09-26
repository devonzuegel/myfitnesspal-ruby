module API
  module Workers
    class Sync
      include Sidekiq::Worker

      def perform(packets, db_uri, user_id)
        Builders::Sync.call(packets, SqlRepo.new(db_uri), user_id)
      end
    end
  end
end

