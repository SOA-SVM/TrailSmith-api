# frozen_string_literal: true

require_relative 'helpers/spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Maps API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Store spot' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save spot from Maps to database' do
      spot = TrailSmith::GoogleMaps::SpotMapper
        .new(GOOGLE_MAPS_KEY)
        .find(TEXT_QUERY)

      rebuilt = TrailSmith::Repository::For.entity(spot).create(spot)

      _(rebuilt.place_id).must_equal(spot.place_id)
      _(rebuilt.formatted_address).must_equal(spot.formatted_address)
      _(rebuilt.display_name).must_equal(spot.display_name)
      _(rebuilt.rating).must_equal(spot.rating)
      _(rebuilt.reviews).must_equal(spot.reviews)
    end
  end
end
