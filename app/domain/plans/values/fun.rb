# frozen_string_literal: true

module TrailSmith
  module Value
    # fun score
    class Fun
      HIGH_THRESHOLD = 4
      LOW_THRESHOLD = 3

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
    end
  end
end
