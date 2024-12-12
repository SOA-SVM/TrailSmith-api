#  frozen_string_literal: true

require 'google-maps'

module TrailSmith
  module Route
    # Library for Google Maps Route API
    class Api
      def initialize(token)
        @token = token
      end

      def route_data(starting_spot, next_spot, mode = 'walking')
        Request.new(@token).get_route(starting_spot, next_spot, mode)
      end

      def spot_detail(place_id)
        Request.new(@token).get_spot_detail(place_id)
      end

      # send out HTTP request to Google Cloud Translation
      class Request
        def initialize(token)
          @token = token

          Google::Maps.configure do |conf|
            conf.authentication_mode = Google::Maps::Configuration::API_KEY
            conf.api_key = @token
          end
        end

        def get_route(starting_spot, next_spot, mode)
          starting_spot = fetch_spot(starting_spot.place_id)
          next_spot = fetch_spot(next_spot.place_id)
          route = build_route(starting_spot, next_spot, mode:)
          route if data?(route)
        end

        def get_spot_detail(place_id)
          fetch_spot(place_id)
        end

        def fetch_spot(place_id)
          Google::Maps.place(place_id)
        rescue StandardError => err
          raise Errors.raise_msg(err)
        end

        def build_route(starting_spot, next_spot, mode)
          Google::Maps::Route.new(starting_spot, next_spot, mode:)
        rescue StandardError => err
          raise Errors.raise_msg(err)
        end

        def data?(route)
          route.duration
        rescue StandardError => err
          raise Errors.raise_msg(err)
        end
      end

      # Decorates the errors
      class Errors
        Forbidden = Class.new(StandardError)
        RouteNotFound = Class.new(StandardError)
        OtherError = Class.new(StandardError)

        ERROR = {
          'REQUEST_DENIED: The provided API key is invalid.' => Forbidden,
          'ZERO_RESULTS: '                                   => RouteNotFound
        }.freeze

        def self.raise_msg(err)
          ERROR[err.message] || OtherError
        end
      end
    end
  end
end
