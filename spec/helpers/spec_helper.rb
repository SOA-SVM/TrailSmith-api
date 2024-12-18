# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../require_app'
require_app

GOOGLE_MAPS_KEY = TrailSmith::App.config.GOOGLE_MAPS_KEY
OPENAI_TOKEN = TrailSmith::App.config.OPENAI_TOKEN

TEXT_QUERY = 'nthu'
STARTING_SPOT = 'nthu'
NEXT_SPOT = 'Hsinchu Train Station'
TRAVEL_MODE = 'walking'
GPT_JSON = '{
"num_people": 2,
"region": "Hsinchu",
"day": 3,
"spots": ["nthu", "Hsinchu Train Station", "Hsinchu Zoo"],
"mode": ["walking", "walking"]
}'
QUERY = 'I want a day trip to Tainan'
# GPT_JSON2 = '{
# "num_people": 2,
# "region": "Hsinchu",
# "day": 3,
# "spots": ["nthu", "Hsinchu Zoo", "Hsinchu Train Station"],
# "mode": ["walking", "walking"]
# }'
MAP_CORRECT = YAML.safe_load_file('spec/fixtures/maps_results.yml', permitted_classes: [Symbol])
