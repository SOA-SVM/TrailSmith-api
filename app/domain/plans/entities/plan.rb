# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'spot'

module TrailSmith
  module Entity
    # Aggregate root for plans
    class Plan < Dry::Struct
      include Dry.Types

      attribute :id,      Integer.optional
      attribute :score,   Strict::Integer
      attribute :type,    Strict::String
      attribute :spots,   Strict::Array.of(Spot)
    end
  end
end
