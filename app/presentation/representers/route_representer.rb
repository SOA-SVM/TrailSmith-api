# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TrailSmith
  module Representer
    # Represents a CreditShare value
    class Route < Roar::Decorator
      include Roar::JSON

      property :starting_spot
      property :next_spot
      property :travel_mode
      property :travel_time
      property :travel_time_desc
      property :distance
      property :distance_desc
      property :overview_polyline
    end
  end
end
