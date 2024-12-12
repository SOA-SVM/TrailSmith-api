# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'report'
require_relative '../values/fun'
require_relative '../values/popular'

module TrailSmith
  module Entity
    # Domain entity for spots
    class Spot < Dry::Struct
      include Dry.Types

      attribute :id,           Integer.optional
      attribute :place_id,     Strict::String
      attribute :name,         Strict::String
      attribute :rating,       Strict::Float
      attribute :rating_count, Strict::Integer
      attribute :reports,      Array.of(Report)
      attribute :address,      Strict::String
      attribute :coordinate,   Strict::Hash

      def fun
        # average fun score of reports
        fun_score = reports.map(&:fun).sum / reports.length
        Value::Fun.new(fun_score)
      end

      def popular
        popular_score = rating_count
        Value::Fun.new(popular_score)
      end

      def keywords
        # array of keywords of reports
        reports.flat_map(&:keywords).uniq
      end

      def to_attr_hash
        to_hash.except(:id, :reports)
      end
    end
  end
end
