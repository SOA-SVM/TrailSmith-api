# frozen_string_literal: true

require 'http'
require 'yaml'

def text_search(config, text_query)
  url = 'https://places.googleapis.com/v1/places:searchText'
  HTTP.headers(
    'X-Goog-Api-Key' => config['GOOGLE_MAPS_KEY'],
    'X-Goog-FieldMask' => 'places.displayName,places.formattedAddress,places.id,places.rating,places.reviews'
  ).post(url, json: { textQuery: text_query })
end

config = YAML.safe_load_file('config/secrets.yml')

maps_response = {}
maps_results = {}

## HAPPY project request
text_query = 'NTHU'
maps_response[text_query] = text_search(config, text_query)
place = maps_response[text_query].parse

maps_results['id'] = place['places'][0]['id']

maps_results['formatted_address'] = place['places'][0]['formattedAddress']
# should be 300新竹市東區光復路二段101號

maps_results['display_name'] = place['places'][0]['displayName']
# should be 清華大學

maps_results['rating'] = place['places'][0]['rating']
# should be 4.6

maps_results['reviews'] = place['places'][0]['reviews']

File.write('spec/fixtures/maps_results.yml', maps_results.to_yaml)
