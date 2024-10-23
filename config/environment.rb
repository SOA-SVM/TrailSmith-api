# frozen_string_literal: true

require 'roda'
require 'yaml'

module TrailSmith
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load_file('config/secrets.yml')
    CLOUD_TOKEN = CONFIG['Google_Translation_Token']
    GOOGLE_MAPS_KEY = CONFIG['GOOGLE_MAPS_KEY']
  end
end
