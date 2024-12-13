# frozen_string_literal: true

require 'http'

module TrailSmith
  module  Openai
    # Library for OpenAI API
    class OpenaiAPI
      def initialize(token)
        @token = token
      end

      def chat_completion(prompt, **options)
        model, max_tokens = self.class.extract_options(options)
        api_response = Request.new(@token).get(prompt, model, max_tokens).parse
        #validate_messages_structure!(api_response)
        # puts "API Response: #{api_response.inspect}"
        api_response['choices']
      end

      def self.extract_options(options, model: 'gpt-4o-mini', max_tokens: 50)
        model = options.fetch(:model, model)
        max_tokens = options.fetch(:max_tokens, max_tokens)
        [model, max_tokens]
      end

      # This class is responsible for sending HTTP requests to the OpenAI API.
      # It builds the request headers and body, and handles the HTTP interaction.
      class Request
        API_PATH = 'https://api.openai.com/v1/chat/completions'

        def initialize(token)
          @token = token
        end

        def get(prompt, model = 'gpt-4o-mini', max_tokens = 50)
          http_response = HTTP.headers(build_headers).post(API_PATH, json: build_body(prompt, model, max_tokens))
          TrailSmith::Openai::OpenaiAPI::Response.new(http_response).validate
        end

        private

        def build_headers
          {
            'Content-Type'  => 'application/json',
            'Authorization' => "Bearer #{@token}"
          }
        end

        def build_body(prompt, model, max_tokens)
          {
            model: model,
            messages: [{ role: 'user', content: prompt }],
            max_tokens: max_tokens
          }
        end
      end

      # This class wraps the HTTP response from the OpenAI API.
      # It provides methods to check if the response was successful and
      # to parse the response body into a structured format.
      class Response < SimpleDelegator
        BadRequest = Class.new(StandardError)
        Unauthorized = Class.new(StandardError)
        RateLimitExceeded = Class.new(StandardError)

        HTTP_ERROR = { 400 => BadRequest, 401 => Unauthorized, 429 => RateLimitExceeded }.freeze

        def successful?
          !HTTP_ERROR.key?(code)
        end

        def error
          HTTP_ERROR[code]&.new("HTTP Error #{code}: #{body}") || StandardError.new("Unexpected error: #{body}")
        end

        def parse
          JSON.parse(body.to_s)
        end

        def parse_content
          parse['choices'].first['message']['content']
        end

        # Validates the response, raising an error if it is not successful
        def validate
          raise_validation_error unless successful?
          self 
        end

        private

        def raise_validation_error
          error_message = error_message_with_details
          raise error || StandardError.new(error_message)
        end

        def error_message_with_details
          "Validation failed with response body: #{body} (HTTP code: #{code})"
        end

        def validate_safely
          successful?
        end
      end
    end
  end
end
