# frozen_string_literal: false

module TrailSmith
  module GoogleMaps
    # build spot entity
    class SpotMapper
      def initialize(key)
        @key = key
      end

      def build_report_array(report_array)
        report_array.map do |report|
          Entity::Report.new(
            id: nil,
            publish_time: report['publishTime'],
            rating: report['rating'].to_f,
            text: report['originalText']['text']
          )
        end
      end

      def build_entity(text_query)
        spot = GoogleMaps::Api.new(@key).place_data(text_query)

        Entity::Spot.new(
          id: nil,
          place_id: spot['id'],
          name: spot['displayName']['text'],
          rating: spot['rating'].to_f,
          rating_count: spot['userRatingCount'],
          reports: build_report_array(spot['reviews'])
        )
      end
    end
  end
end
