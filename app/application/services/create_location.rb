# frozen_string_literal: true

require 'dry/monads'
require 'dry/transaction'

module TrailSmith
  module Service
    # Service object to handle location creation process
    class CreateLocation
      include Dry::Monads[:result]
      include Dry::Transaction

      step :generate_plan
      step :validate_response
      step :create_plan

      private

      def generate_plan(input)
        result = TrailSmith::Openai::OpenaiMapper
          .new(App.config.OPENAI_TOKEN)
          .build_prompt(input[:query], model: 'gpt-4o-mini', max_tokens: 500)

        Success(result.messages.first)
      rescue StandardError => e
        Failure('Could not generate recommendations')
      end

      def validate_response(response)
        return Failure('No valid response received') if response.nil?

        parsed_json = JSON.parse(response)
        required_fields = %w[num_people region day spots mode]

        if required_fields.all? { |field| parsed_json.key?(field) }
          Success(response)
        else
          Failure('Invalid response format')
        end
      rescue JSON::ParserError => e
        Failure('Could not parse response')
      end

      def create_plan(raw_response)
        plan = GoogleMaps::PlanMapper
          .new(App.config.GOOGLE_MAPS_KEY)
          .build_entity(raw_response)
        
        stored_plan = Repository::For.entity(plan).create(plan)
        Success(stored_plan)
      rescue StandardError => e
        Failure('Could not create plan')
      end
    end
  end
end