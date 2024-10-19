# frozen_string_literal: true

require_relative 'spec_helper_maps'

describe 'Tests Google Maps API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<GOOGLE_MAPS_KEY>') { GOOGLE_MAPS_KEY }
    c.filter_sensitive_data('<GOOGLE_MAPS_KEY_ECS>') { CGI.escape(GOOGLE_MAPS_KEY) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Place information' do
    it 'HAPPY: should provide correct place attributes' do
      place =
        TrailSmith::GoogleMaps::SpotMapper
          .new(GOOGLE_MAPS_KEY)
          .find(TEXT_QUERY)
      _(place.id).must_equal CORRECT['id']
      _(place.formatted_address).must_equal CORRECT['formatted_address']
      _(place.display_name).must_equal CORRECT['display_name']
      _(place.rating).must_equal CORRECT['rating']
      _(place.reviews).must_equal CORRECT['reviews']
    end

    it 'BAD: should exception with wrong key' do
      _(proc do
        TrailSmith::GoogleMaps::SpotMapper
          .new('WRONG_KEY')
          .find(TEXT_QUERY)
      end).must_raise TrailSmith::GoogleMaps::Api::Response::BadRequest
    end
  end
end
