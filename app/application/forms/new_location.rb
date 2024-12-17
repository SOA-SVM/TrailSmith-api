# frozen_string_literal: true

require 'dry/validation'

module TrailSmith
  module Forms
    class NewLocation < Dry::Validation::Contract
      params do
        required(:query).filled(:string)
      end

      rule(:query) do
        key.failure('must not be empty') if value.nil? || value.empty?
        key.failure('must be between 2 and 100 characters') unless (2..100).cover?(value.length)
      end
    end
  end
end