# frozen_string_literal: false

require 'json'
require_relative 'spot_mapper'
require_relative 'route_mapper'

module TrailSmith
  module GoogleMaps
    # build plan entity
    class PlanMapper
      def initialize(key)
        @key = key
        @gpt_dict = nil
      end

      def build_entity(gpt_json)
        @gpt_dict ||= JSON.parse(gpt_json)
        TrailSmith::Entity::Plan.new(
          id: nil,
          spots:,
          routes:,
          region: @gpt_dict['region'],
          num_people: @gpt_dict['num_people'],
          day: @gpt_dict['day']
        )
      end

      def spots
        @spots ||= build_spot_array(@gpt_dict['spots'])
      end

      def routes
        @routes ||= spots.each_cons(2).zip(@gpt_dict['mode']).map do |(starting_spot, next_spot), mode|
          TrailSmith::Mapper::Route.new(@key).find(starting_spot, next_spot, mode)
        end
      end

      private

      def build_spot_array(name_array)
        name_array.map do |name|
          SpotMapper.new(@key).find(name)
        end
      end
    end
  end
end
