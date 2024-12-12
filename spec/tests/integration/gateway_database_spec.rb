# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

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

    it 'HAPPY: Report Database' do
      spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(TEXT_QUERY)

      (0..4).each do |i|
        report = spot.reports[i]
        report_db = TrailSmith::Repository::For.entity(report).create(report)
        _(report_db.publish_time).must_equal report.publish_time
        _(report_db.rating).must_equal report.rating
        _(report_db.text).must_equal report.text
      end
    end
    it 'HAPPY: Spot Database' do
      spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(TEXT_QUERY)
      spot_db = TrailSmith::Repository::For.entity(spot).create(spot)

      (0..4).each do |i|
        report = spot.reports[i]
        report_db = TrailSmith::Repository::For.entity(report).create(report)
        _(report_db.publish_time).must_equal report.publish_time
        _(report_db.rating).must_equal report.rating
        _(report_db.text).must_equal report.text
      end
    end
  end
end
