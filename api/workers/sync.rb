module API
  module Workers
    class Sync < Base
      include Sidekiq::Worker

      def perform(params, user_id, repo_uri = nil)
        packets = get_packets(params)
        puts "Calling Builders::Sync with...: packets.length = #{packets.length}".gray
        Builders::Sync.call(packets, repo(repo_uri), user_id)
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

