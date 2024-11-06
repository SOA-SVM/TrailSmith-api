# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Project Entities
    class SpotOrm < Sequel::Model(:spots)
      many_to_many :plans,
                   class: :'CodePraise::Database::PlanOrm',
                   join_table: :plans_spots,
                   left_key: :spot_id, right_key: :plan_id

      plugin :timestamps, update_on_create: true
    end
  end
end
