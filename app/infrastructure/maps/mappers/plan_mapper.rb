# frozen_string_literal: false

require 'json'
require_relative 'spot_mapper'
require_relative 'way_mapper'

module TrailSmith
  module GoogleMaps
    # build plan entity
    class PlanMapper
      def initialize(key)
        @key = key
      end

      def build_spot_array(name_array)
        name_array.map do |name|
          SpotMapper.new(@key).build_entity(name)
        end
      end

      def build_way_array(spot_array, travel_mode_array)
        (0...travel_mode_array.length).map do |i|
          starting_spot = spot_array[i].place_id
          next_spot = spot_array[i + 1].place_id
          travel_mode = travel_mode_array[i]
          Distance::WayMapper.new(@key).find(starting_spot, next_spot, travel_mode)
        end
      end

      def build_entity(gpt_json) # rubocop:disable Metrics/MethodLength
        gpt_dict = JSON.parse(gpt_json)
        spots = build_spot_array(gpt_dict['spots'])
        travelling = build_way_array(spots, gpt_dict['travelling'])
        TrailSmith::Entity::Plan.new(
          id: nil,
          spots: spots,
          travelling: travelling,
          region: gpt_dict['region'],
          num_people: gpt_dict['num_people'],
          day: gpt_dict['day']
        )
      end
    end
  end
end
