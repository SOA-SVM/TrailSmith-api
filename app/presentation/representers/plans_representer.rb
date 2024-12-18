# frozen_string_literal: true

require 'ostruct'
require 'roar/decorator'
require 'roar/json'

require_relative 'plan_representer'

module TrailSmith
  module Representer
    # Represents lisst of plans for API output
    class PlansList < Roar::Decorator
      include Roar::JSON

      collection :plans, extend: Representer::Plan,
                         class: OpenStruct
    end
  end
end
