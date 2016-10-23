module API
  module Builders
    class Sync
      include Concord.new(:all_packets, :user_id, :db_uri), Procto.call

      SUPPORTED_PACKETS = {
        MFP::Binary::FoodEntry => API::Builders::FoodEntry,
      }.freeze

      def initialize(all_packets, user_id, db_uri = nil)
        super(all_packets, user_id, db_uri)
      end

      def call
        packets.each_with_index do |pkt, i|
          Workers::BuildFoodEntry.perform_async(pkt.to_h, user_id)
        end
      end

      def packets
        all_packets.select { |packet| SUPPORTED_PACKETS.include?(packet.class) }
      end
    end
  end
end
