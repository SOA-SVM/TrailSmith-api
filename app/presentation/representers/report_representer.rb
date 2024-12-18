# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TrailSmith
  module Representer
    # Represents a CreditShare value
    class Report < Roar::Decorator
      include Roar::JSON

      property :publish_time
      property :rating
      property :text
      property :keywords
      property :fun
    end
  end
end
