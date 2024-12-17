# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Spot Entities
    class SpotOrm < Sequel::Model(:spots)
      many_to_many :plans,
                   class: :'TrailSmith::Database::PlanOrm',
                   join_table: :plans_spots,
                   left_key: :spot_id, right_key: :plan_id,
                   order: :position
      one_to_many :reports,
                  class: :'TrailSmith::Database::ReportOrm',
                  key: :spot_id

      plugin :timestamps, update_on_create: true
    end
  end
end
