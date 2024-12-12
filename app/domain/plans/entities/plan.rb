# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'spot'
require_relative '../values/way'

module TrailSmith
  module Entity
    # Aggregate root
    class Plan < Dry::Struct
      include Dry.Types

      attribute :id,         Integer.optional
      attribute :spots,      Strict::Array.of(Spot)
      attribute :region,     Strict::String
      attribute :num_people, Strict::Integer
      attribute :day,        Strict::Integer

      def travelling
        # array of Value object Way
      end

      def add_spot(spot_entity)
        spots << spot_entity
      end

      def to_attr_hash
        to_hash.except(:id, :spots)
      end
    end
  end
end
