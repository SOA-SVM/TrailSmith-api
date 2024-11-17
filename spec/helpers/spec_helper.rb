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

TrailSmith::App.config.GOOGLE_MAPS_KEY
GOOGLE_MAPS_KEY = TrailSmith::App.config.GOOGLE_MAPS_KEY

TEXT_QUERY_LIST = %w[NTHU NYCU NTU].freeze
TEXT_QUERY = 'NTHU'
TYPE = 'RELAX'

MAP_CORRECT = YAML.safe_load_file('spec/fixtures/maps_results.yml', permitted_classes: [Symbol])
