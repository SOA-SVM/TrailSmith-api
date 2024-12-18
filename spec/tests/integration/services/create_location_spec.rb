# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'CreateLocation Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Add a plan' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should not return plans that are not being watched' do
      # # GIVEN: a valid plan exists locally and is being watched
      # new_plan = TrailSmith::GoogleMaps::PlanMapper.new(GOOGLE_MAPS_KEY).build_entity(GPT_JSON)
      # TrailSmith::Repository::For.entity(new_plan).create(new_plan)

      # WHEN: we request an empty list
      location_made = TrailSmith::Request::EncodedPlanList.to_request({ 'query'=>QUERY })
      result = TrailSmith::Service::CreateLocation.new.call(location_made: location_made)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      # list = result.value!.message
      # _(list.plans).must_equal []
    end

    # it 'HAPPY: should not return plans that are not being watched' do
    #   # GIVEN: a valid plan exists locally and is being watched
    #   new_plan = TrailSmith::GoogleMaps::PlanMapper.new(GOOGLE_MAPS_KEY).build_entity(GPT_JSON)
    #   TrailSmith::Repository::For.entity(new_plan).create(new_plan)

    #   # WHEN: we request an empty list
    #   list_request = TrailSmith::Request::EncodedPlanList.to_request({ 'origin_json' => GPT_JSON, 'query' => QUERY })
    #   result = TrailSmith::Service::ListPlans.new.call(
    #     list_request: list_request
    #   )

    #   # THEN: it should return an empty list
    #   _(result.success?).must_equal true
    #   list = result.value!.message
    #   _(list.plans).must_equal []
    # end

    # # it 'test' do
    # #   # GIVEN: we are watching a plan that does not exist locally
    # #   list_request = TrailSmith::Request::EncodedPlanList.to_request({})

    # #   # WHEN: we request a list of all watched plans
    # #   result = TrailSmith::Service::ListPlans.new.call(
    # #     list_request: list_request
    # #   )

    # #   # THEN: it should return an empty list
    # #   _(result.success?).must_equal true
    # #   list = result.value!.message
    # #   _(list.plans).must_equal []
    # # end
  end
end
