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


      # 新增一個 class method 生成 prompt
      def self.build_prompt(query)
        <<~PROMPT
          Generates travel itineraries based on location: #{query}

          Required JSON format:
          {
            "num_people": Integer (default: 2),
            "region": String (location area/city),
            "day": Integer (default: 1),
            "spots": Array[String] (min 2, recommended 4 spots),
            "mode": Array[String] (length = spots.length - 1)
          }

          Rules:
          1. mode must be from: ["walking", "driving", "bicycling", "transit"]
          2. number of mode elements must be exactly (spots.length - 1)
          3. customize to location characteristics
          4. spots should be actual tourist attractions/destinations
          5. return ONLY the JSON object, no additional text

          Example structure (DO NOT use these values, generate based on #{query}):
          {
            "num_people": 2,
            "region": "Kyoto",
            "day": 2,
            "spots": [
              "Kinkaku-ji",
              "Arashiyama Bamboo Grove",
              "Fushimi Inari Shrine",
              "Nijo Castle"
            ],
            "mode": ["walking", "transit", "walking"]
          }
        PROMPT
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
            choice['message']['content'] if choice.is_a?(Hash) && choice['message'].is_a?(Hash)
          end.compact
        end
      end
    end
  end
end
