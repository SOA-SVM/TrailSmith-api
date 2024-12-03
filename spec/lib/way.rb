# frozen_string_literal: true

module TrailSmith
  # Provide access to distance data
  class Way
    attr_reader :mode

    def initialize(way_data, mode)
      @data = way_data
      @mode = mode
    end

    def starting_spot
      @data.origin.address.gsub('place_id:', '')
    end

    def next_spot
      @data.destination.address.gsub('place_id:', '')
    end

    def travel_time
      @data.duration_in_seconds
    end

    def travel_time_desc
      @data.duration_text
    end

    def distance
      @data.distance_in_meters
    end

    def distance_desc
      @data.distance_text
    end
  end
end
