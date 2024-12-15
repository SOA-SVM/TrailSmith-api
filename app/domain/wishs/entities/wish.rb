# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

module TrailSmith
  module Entity
    # Domain entity for OpenAI responses
    class Wish < Dry::Struct
      include Dry.Types

      attribute :messages, Strict::Array.of(String)
    end
  end
end
