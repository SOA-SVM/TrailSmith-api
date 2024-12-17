# frozen_string_literal: true

require 'dry/monads'

module TrailSmith
  module Service
    # Service to create new location plan using OpenAI and Google Maps
    class CreateLocation
      include Dry::Monads::Result::Mixin

      def call(input)
        # Call OpenAI to generate recommendations
        wish_result = TrailSmith::Openai::OpenaiMapper
          .new(App.config.OPENAI_TOKEN)
          .build_prompt(input[:query], model: 'gpt-4o-mini', max_tokens: 500)

        return Failure('No recommendations received') unless wish_result&.messages&.any?

        raw_response = wish_result.messages.first
        parsed_json = validate_response(raw_response)
        return parsed_json if parsed_json.failure?

        # Create plan from response
        plan = GoogleMaps::PlanMapper
          .new(App.config.GOOGLE_MAPS_KEY)
          .build_entity(raw_response)

        # Store in database
        stored_plan = Repository::For.entity(plan).create(plan)
        Success(stored_plan)
      rescue StandardError => e
        puts "Error in CreateLocation service: #{e.message}"
        case e.message
        when /already exists/
          Failure('This plan already exists')
        else
          Failure('Could not create location')
        end
      end

      private

      def validate_response(response)
        parsed_json = JSON.parse(response)
        required_fields = %w[num_people region day spots mode]

        if required_fields.all? { |field| parsed_json.key?(field) }
          Success(parsed_json)
        else
          Failure('Invalid response format from OpenAI')
        end
      rescue JSON::ParserError
        Failure('Could not parse OpenAI response')
      end
    end
  end
end