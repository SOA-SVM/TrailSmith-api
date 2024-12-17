# frozen_string_literal: true

module TrailSmith
  module Value
    # popular score
    class Tiredness
      HIGH_THRESHOLD = 150
      LOW_THRESHOLD = 50

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
