#  frozen_string_literal: true

require 'http'
require 'dry/monads'

module TrailSmith
  module Service
    # Proxy Google Maps JS API requests
    class GoogleMapsProxy
      include Dry::Monads::Result::Mixin

      def fetch_map_script(token)
        url = build_url(token)
        response = HTTP.get(url)
        process_response(response)
      end

      private

      def build_url(token)
        "https://maps.googleapis.com/maps/api/js?key=#{token}&callback=initMap&libraries=marker"
      end

      def process_response(response)
        status = response.status
        if status.success?
          Success(response.to_s)
        else
          Failure("Google Maps API returned status #{status}")
        end
      rescue StandardError => err
        Failure("Google Maps API error: #{err.message}")
      end
    end
  end
end
