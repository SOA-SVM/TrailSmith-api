# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module TrailSmith
  module Value
    # The travel route between two spots
    class Route < Dry::Struct
      include Dry.Types

      attribute :starting_spot,     Entity::Spot
      attribute :next_spot,         Entity::Spot
      attribute :travel_mode,       Strict::String
      attribute :travel_time,       Strict::Integer
      attribute :travel_time_desc,  Strict::String
      attribute :distance,          Strict::Integer
      attribute :distance_desc,     Strict::String
      attribute :overview_polyline, Strict::String

      # Calculates the relaxing index based on travel mode, distance, and travel time
      # def relaxing
      #   base_relaxing = case @travel_mode
      #                   when :walking then 10
      #                   when :bicycling then 8
      #                   when :driving then 5
      #                   when :transit then 7
      #                   else 3
      #                   end

      #   # Adjust relaxing score based on distance and travel time
      #   adjustment = (@distance / 10.0) + (@travel_time / 60.0)
      #   [base_relaxing - adjustment, 0].max.round(2)
      # end
    end
  end
end
