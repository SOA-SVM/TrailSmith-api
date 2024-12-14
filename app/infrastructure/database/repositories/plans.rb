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
        plan_hash[:spots] = rebuild_spots(db_plan)
        plan_hash[:routes] = rebuild_routes(db_plan)
        Entity::Plan.new(plan_hash)
      end

      private_class_method def self.rebuild_spots(db_plan)
        db_plan.spots.map do |db_spot|
          Repository::Spots.rebuild_entity(db_spot)
        end
      end

      private_class_method def self.rebuild_routes(db_plan)
        db_plan.routes.map do |db_route|
          Repository::Routes.rebuild_entity(db_route)
        end
      end

      def self.create(entity)
        raise 'Entity already exists in database' if find(entity)

        db_plan = Database::PlanOrm.create(entity.to_attr_hash)

        create_and_connect_spots_db(entity, db_plan)
        create_and_connect_routes_db(entity, db_plan)

        rebuild_entity(db_plan)
      end

      private_class_method def self.create_and_connect_spots_db(entity, db_plan)
        entity.spots.each do |spot|
          db_plan.add_spot(Database::SpotOrm.create(spot.to_attr_hash)) # connect spot and plan
        end
      end

      private_class_method def self.create_and_connect_routes_db(entity, db_plan)
        entity.routes.each do |route|
          db_plan.add_route(Database::RouteOrm.create(route.to_attr_hash)) # connect route and plan
        end
      end
    end
  end
end
