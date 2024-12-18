# frozen_string_literal: true

require_relative '../../../helpers/spec_helper_openai'
require 'irb'

describe 'Test OpenAI API liabrary' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<OPENAI_TOKEN>') { OPENAI_TOKEN }
    c.filter_sensitive_data('<OPENAI_TOKEN_ESC>') { CGI.escape(OPENAI_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'OpenAI Information' do
    it 'HAPPY: should provide a successful response from the API' do
      mapper = TrailSmith::Openai::OpenaiMapper.new(OPENAI_TOKEN)
      response = mapper.find(QUESTION)
      puts "Test Response: #{response.inspect}"
      _(response).must_be_instance_of TrailSmith::Entity::Wish
      _(response.messages).wont_be_empty # 檢查 messages 不為空
      _(response.messages.first).must_include EXPECTED_RESPONSE # 檢查包含期望值
    end

    it 'SAD: should gracefully handle an invalid API token' do
      mapper = TrailSmith::Openai::OpenaiMapper.new('BAD_TOKEN')

      assert_raises(TrailSmith::Openai::OpenaiAPI::Response::Unauthorized) do
        mapper.find(QUESTION, model: 'gpt-4o-mini', max_tokens: 50)
      end
    end
  end
end
