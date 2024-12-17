# frozen_string_literal: true

require 'dry-validation'

module TrailSmith
  module Forms
    # URL validation for new location request
    class NewLocation < Dry::Validation::Contract
      # URL format regex
      QUERY_REGEX = /^[A-Za-z0-9\s\u4e00-\u9fa5,.'-]+$/

      params do
        required(:query).filled(:string)
      end

      rule(:query) do
        unless QUERY_REGEX.match?(value)
          key.failure('must be a valid input with only letters, numbers, and basic punctuation')
        end
      end
    end
  end
end