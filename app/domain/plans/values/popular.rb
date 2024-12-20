# frozen_string_literal: true

module TrailSmith
  module Value
    # popular score
    class Popular
      HIGH_THRESHOLD = 1000
      LOW_THRESHOLD = 100

      attr_reader :value

      def initialize(value)
        @value = value
      end

      def high?
        @value >= HIGH_THRESHOLD
      end

      def medium?
        @value > LOW_THRESHOLD && @value < HIGH_THRESHOLD
      end

      def low?
        @value <= LOW_THRESHOLD
      end

      def not_available?
        @value.zero?
      end
    end
  end
end
