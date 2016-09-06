module API
  module Builders
    class Sync
      include Concord.new(:all_packets, :repo, :user_id), Procto.call

      SUPPORTED_PACKETS = {
        MFP::Binary::FoodEntry => API::Builders::FoodEntry
      }.freeze

      def call
        packets.each { |pkt| BuildFoodEntry.call(pkt, repo, user_id) }
      end

      def packets
        all_packets.select { |packet| SUPPORTED_PACKETS.include?(packet.class) }
      end

      class BuildFoodEntry
        include Concord.new(:packet, :repo, :user_id), Procto.call

        def call
          food_id      = Builders::Food.call(packet.food, repo)[:id]
          portion_list = Builders::FoodPortionList.call(packet.food.portions, food_id, repo)
          portion_id   = portion_list[hash_packet[:weight_index]][:id]

          Builders::FoodEntry.call(hash_packet, portion_id, user_id, repo)
        end

        def builder
          Sync::SUPPORTED_PACKETS.fetch(packet.class)
        end

        def hash_packet
          packet.to_h
        end
      end
    end
  end
end
