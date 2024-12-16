# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module TrailSmith
  module Entity
    # Domain entity for travel spots
    class Report < Dry::Struct
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :publish_time,  Strict::String
      attribute :rating,        Strict::Float
      attribute :text,          Strict::String

      def keywords
        # GPT keywords from the review text
        prompt = '1. The keyword with one or two words from the prompt that could most describe the characteristic
                     of the spot for the tourist.
                  2. Do not give me a description of why choosing the keyword.
                  3. Dont give me the name of the spot.
                  4. Word start with capital letter, e.g. Beautiful Campus'
        question = "Review: #{text} Prompt: #{prompt}"
        gpt = Openai::OpenaiMapper.new(App.config.OPENAI_TOKEN)
        gpt.find(question).messages.first
      end

      def fun
        # fun score = (review rating + GPT rating) / 2
        prompt = '1. Rate how fun the spot is according to the text.
                  2. The maximum is 5 and the minimum is 0.
                  3. Just give the score'
        question = "Review: #{text} Prompt: #{prompt}"
        gpt = Openai::OpenaiMapper.new(App.config.OPENAI_TOKEN)
        response = gpt.find(question).messages.first
        (response.to_f + rating) / 2
      end

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
