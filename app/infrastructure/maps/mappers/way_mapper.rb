#  frozen_string_literal: true

module TrailSmith
  module Distance
    # Get the way how to move between two spots
    class WayMapper
      def initialize(token, gateway_class = Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(starting_spot, next_spot, mode = 'transit')
        data = @gateway.way_data(starting_spot, next_spot, mode)
        WayMapper.to_value(data, mode)
      end

      def self.to_value(data, mode)
        DataMapper.new(data, mode).to_value
      end

      # Extracts value object specific elements from data structure
      class DataMapper
        attr_reader :travel_mode, :data

        def initialize(data, mode)
          @data = data
          @travel_mode = mode
        end

        def to_value
          Value::Way.new(info, travel_detail)
        end

        private

        def info
          {
            starting_spot:,
            next_spot:,
            num_people: 2, # default 2 people
            travel_mode:
          }
        end

        def travel_detail
          {
            travel_time:,
            travel_time_desc:,
            distance:,
            distance_desc:
          }
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
  end
end
