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
        loc = [starting_spot, next_spot]
        Route.to_value(data, mode, loc)
      end

      def self.to_value(data, mode, loc)
        DataMapper.new(data, mode, loc).to_value
      end

      # Extracts value object specific elements from data structure
      class DataMapper
        attr_reader :travel_mode, :data, :starting_spot, :next_spot

        def initialize(data, mode, loc)
          @data = data
          @travel_mode = mode
          @starting_spot = loc[0]
          @next_spot = loc[1]
        end

        def to_value
          Value::Route.new(
            starting_spot:,
            next_spot:,
            travel_mode:,
            travel_time:,
            travel_time_desc:,
            distance:,
            distance_desc:,
            overview_polyline:
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

        def overview_polyline
          @data.instance_variable_get(:@route).overview_polyline.points
        end
      end
    end
  end
end
