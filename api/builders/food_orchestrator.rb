module API
  module Builders
    class FoodOrchestrator
      include Utils

      include Concord.new(:packet, :repo, :user_id), Procto.call

      def initialize(packet, repo, user_id)
        super(symbolize_keys(packet), repo, user_id)
      end

      def call
        food_id      = Builders::Food.new(food, repo).first_or_create.fetch(:id)
        portion_list = Builders::FoodPortionList.call(food.fetch(:portions), food_id, repo)
        portion_id   = portion_list[packet[:weight_index]][:id]

        Builders::FoodEntry.call(packet, portion_id, user_id, repo)
      end

      def food
        packet.fetch(:food)
      end
    end
  end
end
