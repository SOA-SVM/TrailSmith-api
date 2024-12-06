# frozen_string_literal: true

require 'google_distance_matrix'
require 'yaml'
require 'irb'

config = YAML.safe_load_file('config/secrets.yml')
GOOGLE_MAPS_KEY = config['development']['GOOGLE_MAPS_KEY']

# origins = ['國立清華大學, 新竹市, 台灣']
# destinations = ['新竹火車站, 新竹市, 台灣']
origin = 'ChIJB7ZNzXI2aDQREwR22ltdKxE' # place_id for nthu
destination = 'ChIJBXLgwuk1aDQRuu4aKYS0jF4' # place_id for Hsinchu train station
mode = 'walking' # mode：'driving', 'walking', 'bicycling', 'transit'

matrix = GoogleDistanceMatrix::Matrix.new

# origins.each { |origin| matrix.origins << GoogleDistanceMatrix::Place.new(address: origin) }
# destinations.each { |destination| matrix.destinations << GoogleDistanceMatrix::Place.new(address: destination) }
matrix.origins << GoogleDistanceMatrix::Place.new(address: "place_id:#{origin}")
matrix.destinations << GoogleDistanceMatrix::Place.new(address: "place_id:#{destination}")

matrix.configure do |conf|
  conf.google_api_key = GOOGLE_MAPS_KEY
  conf.mode = mode
end

response = matrix.data.first.first
result = {}

result['starting_spot'] = { 'place_id' => response.origin.address.gsub('place_id:', '') }
result['next_spot'] = { 'place_id' => response.destination.address.gsub('place_id:', '') }
result['distance'] = {
  'desc'  => response.distance_text,
  'meter' => response.distance_in_meters
}
result['travel_time'] = {
  'desc' => response.duration_text,
  'sec'  => response.duration_in_seconds
}
result['travel_mode'] = matrix.configuration.mode

file_path = 'spec/fixtures/distance_api_results.yml'
File.write(file_path, result.to_yaml)
