# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Plan Entities
    class PlanOrm < Sequel::Model(:plans)
      many_to_many :spots,
                   class: :'TrailSmith::Database::SpotOrm',
                   join_table: :plans_spots,
                   left_key: :plan_id, right_key: :spot_id
      one_to_many :routes,
                  class: :'TrailSmith::Database::RouteOrm',
                  key: :plan_id

      plugin :timestamps, update_on_create: true
    end
  end
end
