# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Spot Entities
    class RouteOrm < Sequel::Model(:routes)
      many_to_one :plan,
                  class: :'TrailSmith::Database::PlanOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
