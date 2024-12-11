#  frozen_string_literal: true

module TrailSmith
  module Mapper
    # Get the route between two spots
    class Route
      def initialize(token, gateway_class = TrailSmith::Route::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(starting_spot, next_spot, mode = 'driving')
        data = @gateway.route_data(starting_spot, next_spot, mode)
        Route.to_value(data, mode, starting_spot, next_spot)
      end

      def self.to_value(data, mode, starting_spot, next_spot)
        DataMapper.new(data, mode, starting_spot, next_spot).to_value
      end

      # Extracts value object specific elements from data structure
      class DataMapper
        attr_reader :travel_mode, :data, :starting_spot, :next_spot

        def initialize(data, mode, starting_spot, next_spot)
          @data = data
          @travel_mode = mode
          @starting_spot = starting_spot
          @next_spot = next_spot
        end

        def to_value
          Value::Route.new(
            starting_spot:,
            next_spot:,
            travel_mode:,
            travel_time:,
            travel_time_desc:,
            distance:,
            distance_desc:
          )
        end

        private

        def travel_time
          @data.duration.value # in sec
        end

        def travel_time_desc
          @data.duration.text
        end

        def distance
          @data.distance.value # in meters
        end

        def distance_desc
          @data.distance.text
        end
      end
    end
  end
end
