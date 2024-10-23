<<<<<<< HEAD
# frozen_string_literal: true
=======
 frozen_string_literal: true
>>>>>>> 3d531ef... refactor: Maps refactor to enterprise design patterns

require 'http'

module TrailSmith
  module GoogleMaps
    # Library for Github Web API
    class Api
      def initialize(key)
        @key = key
      end

      def place_data(text_query)
        Request.new(@key).text_search(text_query).parse
      end

      # Sends out HTTP requests to Github
      class Request
        def initialize(key)
          @key = key
        end

        def text_search(text_query)
          url = 'https://places.googleapis.com/v1/places:searchText'
          http_response = HTTP.headers(
            'X-Goog-Api-Key' => @key,
            'X-Goog-FieldMask' => 'places.displayName,places.formattedAddress,places.id,places.rating,places.reviews'
          ).post(url, json: { textQuery: text_query })

          Response.new(http_response).tap do |response|
            raise response.error unless response.successful?
          end
        end
      end

      # Decorates HTTP responses
      class Response < SimpleDelegator
        BadRequest = Class.new(StandardError)
        Forbidden = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          400 => BadRequest,
          403 => Forbidden,
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end

# require_relative '../entities/spot'
# require_relative '../mappers/spot_mapper'

<<<<<<< HEAD
# # GOOGLE_MAPS_KEY = 'WRONG'
# TEXT_QUERY = 'NTHU'
# test = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).find(TEXT_QUERY)
=======
# GOOGLE_MAPS_KEY = 'WRONG'
# TEXT_QUERY = 'NTHU'
# TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).find(TEXT_QUERY)
>>>>>>> 3d531ef... refactor: Maps refactor to enterprise design patterns
