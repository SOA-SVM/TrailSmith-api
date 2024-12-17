# frozen_string_literal: true

require_relative 'spots'
require_relative 'reports'

module TrailSmith
  module Repository
    class Plans # rubocop:disable Style/Documentation
      def self.all
        Database::PlanOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        db_plans = Database::PlanOrm.where(region: entity.region, day: entity.day).all
        db_record = nil
        db_plans.each do |db_plan|
          db_record = db_plan if db_plan.spots.map(&:place_id) == entity.spots.map(&:place_id)
        end
        rebuild_entity(db_record)
      end

      def self.find_id(plan_id)
        rebuild_entity Database::PlanOrm.find(id: plan_id)
      end

      def self.find_ids(plan_ids)
        plan_ids.map do |plan_id|
          find_id(plan_id)
        end.compact
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
        raise 'Plan Entity already exists in database' if find(entity)

        db_plan = Database::PlanOrm.create(entity.to_attr_hash)

        create_and_connect_spots_db(entity, db_plan)
        create_and_connect_routes_db(entity, db_plan)

        rebuild_entity(db_plan)
      end

      private_class_method def self.create_and_connect_spots_db(entity, db_plan)
        entity.spots.each do |spot|
          db_spot = Database::SpotOrm.find(place_id: spot.place_id)
          unless db_spot
            # connect report and spot
            db_spot = Database::SpotOrm.create(spot.to_attr_hash)
            create_and_connect_reports_db(spot, db_spot)
          end
          # connect spot and plan
          db_plan.add_spot_with_position(db_spot)
        end
      end

      private_class_method def self.create_and_connect_reports_db(entity, db_spot)
        return if entity.reports.nil?

        entity.reports.each do |report|
          db_spot.add_report(Database::ReportOrm.create(report.to_attr_hash)) # connect route and plan
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
