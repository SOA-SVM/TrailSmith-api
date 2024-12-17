# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'tiredness'

module TrailSmith
  module Value
    # The travel route between two spots
    class Route < Dry::Struct
      include Dry.Types

      attribute :id,                Strict::Integer.optional
      attribute :starting_spot,     Strict::String
      attribute :next_spot,         Strict::String
      attribute :travel_mode,       Strict::String
      attribute :travel_time,       Strict::Integer
      attribute :travel_time_desc,  Strict::String
      attribute :distance,          Strict::Integer
      attribute :distance_desc,     Strict::String
      attribute :overview_polyline, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end

      # Calculates the relaxing index based on travel mode, distance, and travel time
      def tiredness
        weight = case travel_mode
                 when 'walking' then 10
                 when 'bicycling' then 8
                 when 'transit' then 6
                 when 'driving' then 4
                 else 3
                 end

        # Adjust relaxing score based on distance and travel time
        score = (distance / 1000.0) + (travel_time / 60.0)
        Tiredness.new(weight * score)
      end
    end
  end
end
