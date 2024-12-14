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

      spot.reports.each do |report|
        rebuilt_report = TrailSmith::Repository::For.entity(report).create(report)
        _(rebuilt_report.publish_time).must_equal report.publish_time
        _(rebuilt_report.rating).must_equal report.rating
        _(rebuilt_report.text).must_equal report.text
      end
    end
    it 'HAPPY: Spot Database' do
      spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(TEXT_QUERY)
      rebuilt_spot = TrailSmith::Repository::For.entity(spot).create(spot)

      _(rebuilt_spot.place_id).must_equal spot.place_id
      _(rebuilt_spot.name).must_equal spot.name
      _(rebuilt_spot.rating).must_equal spot.rating
      _(rebuilt_spot.rating_count).must_equal spot.rating_count
      _(rebuilt_spot.address).must_equal spot.address

      rebuilt_spot.reports.zip(spot.reports) do |rebuilt_report, report|
        _(rebuilt_report.publish_time).must_equal report.publish_time
        _(rebuilt_report.rating).must_equal report.rating
        _(rebuilt_report.text).must_equal report.text
      end
    end
  end
end
