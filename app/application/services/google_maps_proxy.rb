#  frozen_string_literal: true

require 'http'

module TrailSmith
  module Service
    # Proxy Google Maps JS API requests
    class GoogleMapsProxy
      def self.fetch_map_script(token)
        url = "https://maps.googleapis.com/maps/api/js?key=#{token}&callback=initMap&libraries=marker"
        response = HTTP.get(url)
        response.to_s
      rescue StandardError => err
        raise "Google Maps API error: #{err.message}"
      end
    end
  end
end
