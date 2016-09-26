module API
  module Builders
    class Sync
      include Concord.new(:all_packets, :repo, :user_id), Procto.call

      SUPPORTED_PACKETS = {
        MFP::Binary::FoodEntry => API::Builders::FoodEntry
      }.freeze

      def call
        packets.each do |pkt|
          Workers::BuildFoodEntry.perform_async(pkt.to_h, repo, user_id)
        end
      end

      def packets
        all_packets.select { |packet| SUPPORTED_PACKETS.include?(packet.class) }
      end
    end
  end
end
