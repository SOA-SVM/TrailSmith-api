# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module TrailSmith
  module Entity
    # Domain entity for travel spots
    class Spot < Dry::Struct
      include Dry.Types

      attribute :id,                Integer.optional
      attribute :place_id,          Strict::String
      attribute :formatted_address, Strict::String
      attribute :display_name,      Strict::String
      attribute :rating,            Strict::Float
      attribute :reviews,           Strict::Array

      def score
        num = reviews.length + 1
        sum = reviews.sum { |review| review[:rating] } + rating
        (sum / num).round(2)
      end

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
