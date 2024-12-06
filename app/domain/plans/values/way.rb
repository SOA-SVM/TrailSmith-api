# frozen_string_literal: true

module TrailSmith
  module Value
    # The travel way between two spots
    class Way
      # Initializes the Way value object
      def initialize(info, travel_detail)
        @info = info
        @travel_detail = travel_detail
      end

      def starting_spot
        @info[:starting_spot]
      end

      def next_spot
        @info[:next_spot]
      end

      def num_people
        @info[:num_people]
      end

      def travel_mode
        @info[:travel_mode]
      end

      def travel_time
        @travel_detail[:travel_time]
      end

      def travel_time_desc
        @travel_detail[:travel_time_desc]
      end

      def distance
        @travel_detail[:distance]
      end

      def distance_desc
        @travel_detail[:distance_desc]
      end

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
