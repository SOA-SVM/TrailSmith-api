# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

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
        _(rebuilt_report.to_attr_hash).must_equal report.to_attr_hash
      end
    end

    it 'HAPPY: Route Database' do
      starting_spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(STARTING_SPOT)
      next_spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(NEXT_SPOT)
      route = TrailSmith::Mapper::Route.new(GOOGLE_MAPS_KEY).find(starting_spot, next_spot, TRAVEL_MODE)
      rebuilt_route = TrailSmith::Repository::For.entity(route).create(route)

      _(rebuilt_route.to_attr_hash).must_equal route.to_attr_hash
    end

    it 'HAPPY: Spot Database' do
      spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(TEXT_QUERY)
      rebuilt_spot = TrailSmith::Repository::For.entity(spot).create(spot)

      _(rebuilt_spot.to_attr_hash).must_equal spot.to_attr_hash

      rebuilt_spot.reports.zip(spot.reports) do |rebuilt_report, report|
        _(rebuilt_report.to_attr_hash).must_equal report.to_attr_hash
      end
    end

    it 'HAPPY: Plan Database' do
      plan = TrailSmith::GoogleMaps::PlanMapper.new(GOOGLE_MAPS_KEY).build_entity(GPT_JSON)
      rebuilt_plan = TrailSmith::Repository::For.entity(plan).create(plan)

      _(rebuilt_plan.to_attr_hash).must_equal plan.to_attr_hash

      rebuilt_plan.spots.zip(plan.spots) do |rebuilt_spot, spot|
        _(rebuilt_spot.to_attr_hash).must_equal spot.to_attr_hash
      end

      rebuilt_plan.routes.zip(plan.routes) do |rebuilt_route, route|
        _(rebuilt_route.to_attr_hash).must_equal route.to_attr_hash
      end
    end
  end
end
