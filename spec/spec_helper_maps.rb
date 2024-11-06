# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

TEXT_QUERY = 'NTHU'
CONFIG = YAML.safe_load_file('config/secrets.yml')
GOOGLE_MAPS_KEY = ENV.fetch('GOOGLE_MAPS_KEY', nil)
CORRECT = YAML.safe_load_file('spec/fixtures/maps_results.yml', permitted_classes: [Symbol])

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'maps_api'
