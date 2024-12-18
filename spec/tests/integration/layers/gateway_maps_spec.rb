# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'

describe 'Tests Google Maps API' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VCR.eject_cassette
  end

  describe 'Map information' do
    it 'HAPPY: Spot attribute' do
      spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(TEXT_QUERY)
      _(spot.place_id).must_equal MAP_CORRECT[:place_id]
      _(spot.name).must_equal MAP_CORRECT[:name]
      _(spot.rating).must_equal MAP_CORRECT[:rating]
      _(spot.rating_count).must_equal MAP_CORRECT[:rating_count]
      _(spot.address).must_equal MAP_CORRECT[:address]

      # check Reports array
      spot.reports.zip(MAP_CORRECT[:reports]).each do |report, correct_report|
        _(report.publish_time).must_equal correct_report[:publish_time]
        _(report.rating).must_equal correct_report[:rating]
        _(report.text).must_equal correct_report[:text]
      end
    end

    it 'BAD: SpotMapper should raise exception with wrong key' do
      _(proc do
        TrailSmith::GoogleMaps::SpotMapper.new('WRONG_KEY').build_entity(TEXT_QUERY)
      end).must_raise TrailSmith::GoogleMaps::Api::Response::BadRequest
    end

    it 'BAD: PlanMapper should raise exception with wrong key' do
      _(proc do
        TrailSmith::GoogleMaps::PlanMapper.new('WRONG_KEY').build_entity(GPT_JSON)
      end).must_raise TrailSmith::GoogleMaps::Api::Response::BadRequest
    end
  end
end
