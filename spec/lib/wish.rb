# frozen_string_literal: true

module TrailSmith
  class Wish
    def initialize(generate_text = {})
      @content = generate_text
      raise "Invalid data: #{@content.inspect}" unless valid_content?
    end

    def messages
      @content['choices'].map { |choice| choice['message'] }
    end

    private

    def valid_content?
      @content.is_a?(Hash) && @content.key?('choices')
    end
  end
end
