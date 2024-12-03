#  frozen_string_literal: true

require 'google_distance_matrix'
require 'yaml'
require_relative 'way'
require 'irb'

module TrailSmith
  # Library for Google Cloud API
  class DistanceApi
    def initialize(token)
      @token = token
    end

    def way(starting_spot, next_spot, mode = 'transit')
      response = Request.new(@token).get(starting_spot, next_spot, mode)
      Way.new(response, mode)
    end

    # send out HTTP request to Google Cloud Translation
    class Request
      def initialize(token)
        @token = token
      end

      def get(starting_spot, next_spot, mode)
        matrix = build_matrix(starting_spot, next_spot, mode)

        Response.new(matrix).tap do |response|
          raise(response.error) unless response.successful?
        end
        matrix.data.first.first
      end

      def build_matrix(starting_spot, next_spot, mode)
        matrix = GoogleDistanceMatrix::Matrix.new
        matrix.origins << GoogleDistanceMatrix::Place.new(address: "place_id:#{starting_spot}")
        matrix.destinations << GoogleDistanceMatrix::Place.new(address: "place_id:#{next_spot}")

        matrix.configure do |conf|
          conf.google_api_key = @token
          conf.mode = mode
        end

        matrix
      end
    end

    # Decorates HTTP responses with success/error
    class Response < SimpleDelegator
      attr_reader :response

      def initialize(response)
        @response = response
        @error = nil
        super
      end

      Forbidden = Class.new(StandardError)
      NotFound = Class.new(StandardError)
      InvalidRequest = Class.new(StandardError)

      HTTP_ERROR = { 400 => NotFound }.freeze
      OTHER_ERROR = { 'REQUEST_DENIED'           => Forbidden,
                      'Configuration is invalid' => InvalidRequest }.freeze

      CLIENT_ERROR = GoogleDistanceMatrix::ClientError
      INVALID_MATRIX = GoogleDistanceMatrix::InvalidMatrix

      def successful?
        @response.data.first.first
        true
      rescue CLIENT_ERROR, INVALID_MATRIX => err
        @error = err
        false
      end

      def error
        if @error.is_a? CLIENT_ERROR
          code = @error.response.code.to_i
          if code == 200
            OTHER_ERROR[@error.status_read_from_api_response]
          else
            HTTP_ERROR[code]
          end
        else
          OTHER_ERROR[@error.message]
        end
      end
    end
  end
end
