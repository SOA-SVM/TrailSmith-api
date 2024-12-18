# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'spot_representer'
require_relative 'route_representer'

module TrailSmith
  module Representer
    # Represents a CreditShare value
    class Plan < Roar::Decorator
      include Roar::JSON

      collection :spots, extend: Representer::Spot, class: OpenStruct
      collection :routes, extend: Representer::Route, class: OpenStruct
      property :region
      property :num_people
      property :day
    end
  end
end
