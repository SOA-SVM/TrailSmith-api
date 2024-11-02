#  frozen_string_literal: true

require 'http'
require 'yaml'

def trans_api_path
    ''
end

def gai_request(api_key, source_texts, target_language)
    HTTP.post(
     
      params: {
        
      }
    )
end

config = YAML.safe_load_file('config/secrets.yml')
api_key = config['GAI_Token']

texts = [
  
]
target_language = 'zh-TW'

response = gai_request(api_key, texts, target_language).parse

translations = response['data']
file_path = ''

File.write(file_path, )

puts 'GAI result saved!'
