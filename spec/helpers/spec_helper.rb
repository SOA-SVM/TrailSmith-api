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

TEXT_QUERY = 'NTHU'
CONFIG = YAML.safe_load_file('config/secrets.yml')
GOOGLE_MAPS_KEY = ENV.fetch('GOOGLE_MAPS_KEY', nil)
# TrailSmith::App.config.GOOGLE_MAPS_KEY
# GOOGLE_MAPS_KEY = TrailSmith::App.config.GOOGLE_MAPS_KEY
MAP_CORRECT = YAML.safe_load_file('spec/fixtures/maps_results.yml', permitted_classes: [Symbol])
