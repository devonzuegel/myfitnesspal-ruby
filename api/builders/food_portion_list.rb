require_relative 'utils'
require_relative '../schema/food_portion'
require_relative '../mappers/food_portion'

module API
  module Builders
    class FoodPortionList
      include Procto.call, Concord.new(:list, :food_id, :repo)

      def call
        list.each_with_index.map do |portion, i|
          FoodPortion.new(portion, i, food_id, repo).first_or_create
        end
      end
    end
  end
end
