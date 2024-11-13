# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Google Maps API library' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
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
      _(place.place_id).must_equal MAP_CORRECT['id']
      _(place.formatted_address).must_equal MAP_CORRECT['formatted_address']
      _(place.display_name).must_equal MAP_CORRECT['display_name']
      _(place.rating).must_equal MAP_CORRECT['rating']
      _(place.reviews).must_equal MAP_CORRECT['reviews']
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
