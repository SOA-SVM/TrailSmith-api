#  frozen_string_literal: true

require 'http'
require 'dry/transaction'

module TrailSmith
  module Service
    # Proxy Google Maps JS API requests
    class GoogleMapsProxy
      include Dry::Transaction

      step :build_url
      step :send_request
      step :process_response

      private

      def build_url(input)
        token = input[:token]
        url = "https://maps.googleapis.com/maps/api/js?key=#{token}&callback=initMap&libraries=marker"
        Success(input.merge(url: url))
      rescue StandardError => err
        Failure(
          Response::ApiResult.new(status: :bad_request, message: err.to_s)
        )
      end

      def send_request(input)
        response = HTTP.get(input[:url])
        Success(input.merge(response: response))
      rescue HTTP::Error => err
        Failure(
          Response::ApiResult.new(status: :bad_request, message: err.to_s)
        )
      end

      def process_response(input)
        response = input[:response]
        if response.status.success?
          Success(status: :ok, message: response.to_s)
        else
          Response::ApiResult.new(status: :bad_request, message: response.status.to_s)
        end
      rescue StandardError => err
        Failure(
          Response::ApiResult.new(status: :cannot_process, message: err.to_s)
        )
      end
    end
  end
end
