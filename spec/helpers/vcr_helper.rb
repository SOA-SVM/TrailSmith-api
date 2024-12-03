# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  MAP_CASSETTE = 'maps_api'
  DISTANCE_CASSETTE = 'distance_api'

  def self.setup_vcr
    VCR.configure do |vcr_config|
      vcr_config.cassette_library_dir = CASSETTES_FOLDER
      vcr_config.hook_into :webmock
    end
  end

  # Unavoidable :reek:TooManyStatements for VCR configuration
  def self.configure_vcr_for_map
    VCR.configure do |vcr_config|
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY>') { GOOGLE_MAPS_KEY }
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY_ECS>') { CGI.escape(GOOGLE_MAPS_KEY) }
    end

    VCR.insert_cassette(
      MAP_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.configure_vcr_for_distance
    VCR.configure do |vcr_config|
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY>') { GOOGLE_MAPS_KEY }
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY_ECS>') { CGI.escape(GOOGLE_MAPS_KEY) }
    end

    VCR.insert_cassette(
      DISTANCE_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
