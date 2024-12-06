#  frozen_string_literal: true

require 'google_distance_matrix'

module TrailSmith
  module Distance
    # Library for Distance Matrix API
    class Api
      def initialize(token)
        @token = token
      end

      def way_data(starting_spot, next_spot, mode = 'transit')
        Request.new(@token).get(starting_spot, next_spot, mode)
      end

      # send out HTTP request to Google Cloud Translation
      class Request
        def initialize(token)
          @token = token
        end

        def get(starting_spot, next_spot, mode)
          matrix = MatrixBuilder.new(starting_spot, next_spot, mode, @token).build

          Response.new(matrix).tap do |response|
            raise(response.error) unless response.successful?
          end
          matrix.data.first.first
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

      # building the GoogleDistanceMatrix object
      class MatrixBuilder
        def initialize(starting_spot, next_spot, mode, token)
          @starting_spot = starting_spot
          @next_spot = next_spot
          @mode = mode
          @token = token
        end

        def build
          matrix = GoogleDistanceMatrix::Matrix.new
          add_spot_to_matrix(matrix)
          configure_matrix(matrix)
          matrix
        end

        private

        def add_spot_to_matrix(matrix)
          matrix.origins << GoogleDistanceMatrix::Place.new(address: "place_id:#{@starting_spot}")
          matrix.destinations << GoogleDistanceMatrix::Place.new(address: "place_id:#{@next_spot}")
        end

        def configure_matrix(matrix)
          matrix.configure do |conf|
            conf.google_api_key = @token
            conf.mode = @mode
          end
        end
      end
    end
  end
end
