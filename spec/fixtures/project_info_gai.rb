# frozen_string_literal: true

require 'http'
require 'yaml'

def openai_api_path
  'https://api.openai.com/v1/chat/completions'
end

def send_openai_request(api_key, messages)
  HTTP.post(
    openai_api_path,
    headers: {
      'Authorization' => "Bearer #{api_key}", 'Content-Type' => 'application/json'
    },
    json: {
      model: 'gpt-4o-mini', messages: messages, temperature: 0.7
    }
  )
end

config = YAML.safe_load_file('config/secrets.yml')
api_key = config['OpenAI_Token']

messages = [
  { role: 'user', content: 'Where is Taiwan?' }
]
openai_result = {}
response = send_openai_request(api_key, messages).parse
openai_result['messages'] = response['choices']

file_path = 'spec/fixtures/openai_response.yml'
File.write(file_path, openai_result.to_yaml)

puts 'OpenAI response saved to spec/fixtures/openai_response.yml'
