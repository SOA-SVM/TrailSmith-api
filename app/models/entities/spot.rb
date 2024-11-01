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
      # attribute :reviews,           Strict::Array.of(Hash.schema(author_name: Strict::String,
      #                                                            rating: Strict::Float,
      #                                                            text: Strict::String))
    end
  end
end
