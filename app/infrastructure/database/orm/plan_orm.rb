# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Plan Entities
    class PlanOrm < Sequel::Model(:plans)
      many_to_many :spots,
                   class: :'TrailSmith::Database::SpotOrm',
                   join_table: :plans_spots,
                   left_key: :plan_id, right_key: :spot_id,
                   order: :position
      one_to_many :routes,
                  class: :'TrailSmith::Database::RouteOrm',
                  key: :plan_id

      # Custom method to add a spot with position
      def add_spot_with_position(spot)
        # Calculate the next position
        next_position = self.class.db[:plans_spots]
          .where(plan_id: id)
          .max(:position) || 0

        # Manually insert into the join table
        self.class.db[:plans_spots].insert(
          plan_id: id,
          spot_id: spot.id,
          position: next_position + 1
        )
      end

      plugin :timestamps, update_on_create: true
    end
  end
end
