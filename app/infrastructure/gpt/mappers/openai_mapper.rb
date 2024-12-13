# frozen_string_literal: true

module TrailSmith
  module Openai
    # Data Mapper: gpt response -> Wish entity
    class OpenaiMapper
      def initialize(token, gateway_class = Openai::OpenaiAPI)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(prompt, **)
        data = @gateway.chat_completion(prompt, **)
        OpenaiMapper.build_entity(data)
      end

      def self.build_entity(api_response)
        DataMapper.new(api_response).build_entity
      end

      # This class maps the raw API response from the OpenAI API
      # into a structured Wish entity, extracting relevant fields like messages.
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          msgs = extract_messages
          puts "Extracted Messages: #{msgs.inspect}"
          TrailSmith::Entity::Wish.new(messages: msgs)
        end

        private

        def extract_messages
          return [] unless @data.is_a?(Array)

          @data.map do |choice|
            if choice.is_a?(Hash) && choice['message'].is_a?(Hash)
              choice['message']['content']
            end
          end.compact
        end
      end
    end
  end
end
