# frozen_string_literal: true

require 'google_distance_matrix'
require 'http'
require 'yaml'
require 'irb'

# 主程式邏輯
config = YAML.safe_load_file('config/secrets.yml')
GOOGLE_MAPS_KEY = config['development']['GOOGLE_MAPS_KEY']

# 定義出發地和目的地
# origins = ['國立清華大學, 新竹市, 台灣']
origin = 'ChIJB7ZNzXI2aDQREwR22ltdKxE' # place_id for nthu
# destinations = ['新竹火車站, 新竹市, 台灣']
destination = 'ChIJBXLgwuk1aDQRuu4aKYS0jF4' # place_id for Hsinchu train station

matrix = GoogleDistanceMatrix::Matrix.new

# 設定出發地和目的地
# origins.each { |origin| matrix.origins << GoogleDistanceMatrix::Place.new(address: origin) }
# destinations.each { |destination| matrix.destinations << GoogleDistanceMatrix::Place.new(address: destination) }
matrix.origins << GoogleDistanceMatrix::Place.new(address: "place_id:#{origin}")
matrix.destinations << GoogleDistanceMatrix::Place.new(address: "place_id:#{destination}")

matrix.configure do |conf|
  conf.google_api_key = GOOGLE_MAPS_KEY
  conf.mode = 'walking' # mode：'driving', 'walking', 'bicycling', 'transit'
end

# 取得距離矩陣資料
response = matrix.data.first.first
result = {}

result['starting_spot'] = { 'place_id' => response.origin.address&.gsub('place_id:', '') }
result['next_spot'] = { 'place_id' => response.destination.address&.gsub('place_id:', '') }
result['distance_desc'] = response.distance_text
result['distance'] = response.distance_in_meters
result['travel_time_desc'] = response.duration_text
result['travel_time'] = response.duration_in_seconds
result['travel_mode'] = matrix.configuration.mode

# 儲存結果到 YAML 檔案
file_path = 'spec/fixtures/distance_matrix_results.yml'
File.write(file_path, result.to_yaml)
