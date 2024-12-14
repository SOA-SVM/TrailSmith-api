# frozen_string_literal: false

require 'irb'

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
        coordinate = Coordinate.new(@key).coordinate(spot['id'])
        Entity::Spot.new(
          id: nil, place_id: spot['id'],
          name: spot['displayName']['text'],
          rating: spot['rating'].to_f,
          rating_count: spot['userRatingCount'],
          reports: build_report_array(spot['reviews']),
          address: spot['formattedAddress'],
          lat: coordinate['lat'],
          lng: coordinate['lng']
        )
      end

      # Find the coordinate for the spot
      class Coordinate
        def initialize(token, gateway_class = Route::Api)
          @token = token
          @gateway_class = gateway_class
          @gateway = @gateway_class.new(@token)
        end

        def coordinate(place_id)
          spot_detail = @gateway.spot_detail(place_id)
          spot_detail.data.geometry.location
        end
      end
    end
  end
end
