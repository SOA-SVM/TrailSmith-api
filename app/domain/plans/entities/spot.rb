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
      attribute :lat,          Strict::Float
      attribute :lng,          Strict::Float

      def coordinate
        { lat: lat, lng: lng }
      end

      def fun
        # average fun score of reports
        @fun ||= begin
          fun_score = reports.map(&:fun).sum / reports.length
          Value::Fun.new(fun_score)
        end
      end

      def popular
        @popular ||= begin
          popular_score = rating_count.to_f
          Value::Popular.new(popular_score)
        end
      end

      def keywords
        # array of keywords of reports
        reports.flat_map(&:keywords).uniq
      end

      def coordinate
        { lat:, lng: }
      end

      def to_attr_hash
        to_hash.except(:id, :reports)
      end
    end
  end
end
