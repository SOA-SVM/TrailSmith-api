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
      attribute :rating,       Strict::Float.optional
      attribute :rating_count, Strict::Integer.optional
      attribute :reports,      Array.of(Report).optional
      attribute :address,      Strict::String
      attribute :lat,          Strict::Float
      attribute :lng,          Strict::Float

      def coordinate
        { lat:, lng: }
      end

      def fun
        # average fun score of reports
        @gpt ||= Openai::OpenaiMapper.new(App.config.OPENAI_TOKEN)
        fun_score = reports.empty? ? 0 : reports.take(3).sum { |report| report.fun(@gpt) } / reports.take(3).length
        Value::Fun.new(fun_score.to_f)
      end

      def popular
        popular_score = rating_count
        Value::Popular.new(popular_score.to_f)
      end

      def keywords
        # array of keywords of reports
        @gpt ||= Openai::OpenaiMapper.new(App.config.OPENAI_TOKEN)
        reports.take(3).map { |report| report.keywords(@gpt) }.uniq
      end

      def to_attr_hash
        to_hash.except(:id, :reports)
      end

      def to_location_map
        {
          'coordinate' => coordinate.to_h,
          'title'      => name
        }
      end
    end
  end
end
