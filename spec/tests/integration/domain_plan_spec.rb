# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'Test Plan Domain Feature' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  it 'HAPPY: Domain Feature' do
    plan = TrailSmith::GoogleMaps::PlanMapper.new(GOOGLE_MAPS_KEY).build_entity(GPT_JSON)
    spot = plan.spots[0]
    report = spot.reports[0]

    _(report.keywords).must_be_instance_of String
    _(report.fun).must_be_instance_of Float

    _(spot.fun.value).must_be_instance_of Float
    _(spot.popular.value).must_be_instance_of Float
    _(spot.keywords).must_be_instance_of Array
  end
end
