# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Project Entities
    class PlanOrm < Sequel::Model(:plans)
      many_to_many :spots,
                   class: :'CodePraise::Database::SpotOrm',
                   join_table: :projects_members,
                   left_key: :plan_id, right_key: :spot_id

      plugin :timestamps, update_on_create: true
    end
  end
end
