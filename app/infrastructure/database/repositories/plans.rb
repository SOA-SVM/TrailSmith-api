# frozen_string_literal: true

require_relative 'spots'

module TrailSmith
  module Repository
    class Plans # rubocop:disable Style/Documentation
      def self.all
        Database::PlanOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        db_record = Database::PlanOrm.find(region: entity.region, day: entity.day)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_plan)
        return nil unless db_plan

        plan_hash = db_plan.to_hash
        plan_hash[:spots] = db_plan.spots.map do |db_spot|
          Repository::Spots.rebuild_entity(db_spot)
        end
        plan_hash[:routes] = db_plan.routes.map do |db_route|
          Repository::Routes.rebuild_entity(db_route)
        end
        Entity::Plan.new(plan_hash)
      end

      def self.create(entity) # rubocop:disable Metrics/MethodLength
        raise 'Entity already exists in database' if find(entity)

        db_plan = Database::PlanOrm.create(entity.to_attr_hash)

        entity.spots.each do |spot|
          db_spot = Database::SpotOrm.create(spot.to_attr_hash)
          db_plan.add_spot(db_spot) # connect spot and plan
        end
        entity.routes.each do |route|
          db_route = Database::RouteOrm.create(route.to_attr_hash)
          db_plan.add_route(db_route) # connect route and plan
        end

        rebuild_entity(db_plan)
      end
    end
  end
end
