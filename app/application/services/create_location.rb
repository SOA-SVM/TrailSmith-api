# frozen_string_literal: true

require 'dry/transaction'

module TrailSmith
  module Service
    # Service to create new location plan using OpenAI and Google Maps
    class CreateLocation
      include Dry::Transaction

      step :validate_input
      step :generate_recommendation
      step :validate_response
      step :create_plan
      step :stored_plan

      private

      def validate_input(input)
        location_made = input[:location_made].call
        if location_made.success?
          query = location_made.value!['query']
          origin_json = location_made.value!['origin_json']
          query = origin_json.to_s + query if origin_json
          query.nil? || query.strip.empty? ? Failure('Invalid input: query is missing') : Success(input.merge(query: query))
        else
          Failure(list_request.failure)
        end
      end

      def generate_recommendation(input)
        wish_result = TrailSmith::Openai::OpenaiMapper
          .new(App.config.OPENAI_TOKEN)
          .build_prompt(input[:query], model: 'gpt-4o-mini', max_tokens: 500)

        if wish_result&.messages&.any?
          Success(input.merge(response: wish_result.messages.first))
        else
          Failure('No recommendations received')
        end
      rescue StandardError => err
        Failure("OpenAI API Error: #{err.message}")
      end

      def validate_response(input)
        parsed_json = JSON.parse(input[:response])
        required_fields = %w[num_people region day spots mode]

        if required_fields.all? { |field| parsed_json.key?(field) }
          Success(input)
        else
          Failure('Invalid response format from OpenAI')
        end
      rescue JSON::ParserError
        Failure('Could not parse OpenAI response')
      end

      def create_plan(input)
        plan = GoogleMaps::PlanMapper
          .new(App.config.GOOGLE_MAPS_KEY)
          .build_entity(input[:response])

        Success(input.merge(plan: plan))
      rescue StandardError => err
        Failure("Error creating plan: #{err.message}")
      end

      def stored_plan(input)
        stored_plan = Repository::For.entity(input[:plan]).create(input[:plan])
        Success(stored_plan)
      rescue StandardError => err
        case err.message
        when /already exists/
          Failure('This plan already exists')
        else
          Failure('Could not create plan, try again.')
        end
      end
    end
  end
end
