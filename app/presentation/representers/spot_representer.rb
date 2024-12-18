# frozen_string_literal: true

require 'ostruct'
require 'roar/decorator'
require 'roar/json'
require_relative 'report_representer'

module TrailSmith
  module Representer
    # Represents a CreditShare value
    class Spot < Roar::Decorator
      include Roar::JSON

      property :place_id
      property :name
      property :rating
      property :rating_count
      collection :reports, extend: Representer::Report, class: OpenStruct
      property :address
      property :lat
      property :lng
      property :coordinate
      property :fun
      property :popular
      collection :keywords
    end
  end
end
