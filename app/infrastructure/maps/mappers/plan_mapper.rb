# frozen_string_literal: false

require_relative 'spot_mapper'

module TrailSmith
  module GoogleMaps
    # Data Mapper: Maps place -> Spot entity
    class PlanMapper
      def initialize(key, text_query_list, type)
        @key = key
        @text_query_list = text_query_list
        @type = type
      end

      def _arrange_plan
        spots = []
        @text_query_list.each do |text_query|
          spot = SpotMapper.new(@key).find(text_query)
          spots << spot
        end
        spots
      end

      def build_entity
        Entity::Plan.new(
          id: nil,
          type: @type,
          score: nil,
          spots: _arrange_plan
        )
      end
    end
  end
end
