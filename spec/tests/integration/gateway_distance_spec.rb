# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Distance Matrix API library' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_distance
  end

  after do
    VCR.eject_cassette
  end
  describe 'Distance information' do
    it 'HAPPY: should provide correct project attributes' do
      way = TrailSmith::Distance::WayMapper.new(GOOGLE_MAPS_KEY)
        .find(STARTING_SPOT, NEXT_SPOT, TRAVEL_MODE)
      _(way.travel_time).must_equal DISTANCE_CORRECT['travel_time']['sec']
      _(way.distance).must_equal DISTANCE_CORRECT['distance']['meter']
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        TrailSmith::Distance::WayMapper.new('BAD_TOKEN').find(STARTING_SPOT, NEXT_SPOT, TRAVEL_MODE)
      end).must_raise TrailSmith::Distance::Api::Response::Forbidden
    end

    it 'SAD: should raise exception on invalid travel mode' do
      _(proc do
        TrailSmith::Distance::WayMapper.new('BAD_TOKEN').find(STARTING_SPOT, NEXT_SPOT, 'hi')
      end).must_raise TrailSmith::Distance::Api::Response::InvalidRequest
    end

    it 'SAD: should raise exception on incorrect spot name' do
      _(proc do
        TrailSmith::Distance::WayMapper.new('BAD_TOKEN').find('no this spot', NEXT_SPOT, TRAVEL_MODE)
      end).must_raise TrailSmith::Distance::Api::Response::NotFound
    end
  end
end
