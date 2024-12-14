# frozen_string_literal: true

require_relative 'reports'

module TrailSmith
  module Repository
    # Repository for Reports
    class Spots
      def self.all
        Database::SpotOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        db_spot = Database::SpotOrm.find(place_id: entity.place_id)
        rebuild_entity(db_spot)
      end

      def self.find_place_id(place_id)
        rebuild_entity Database::SpotOrm.find(place_id: place_id)
      end

      def self.find_place_ids(place_ids)
        place_ids.map do |place_id|
          find_place_id(place_id)
        end.compact
      end

      def self.rebuild_entity(db_spot)
        return nil unless db_spot

        spot_hash = db_spot.to_hash
        spot_hash[:reports] = db_spot.reports.map do |db_report|
          Reports.rebuild_entity(db_report)
        end

        Entity::Spot.new(spot_hash)
      end

      def self.create(entity)
        raise 'Entity already exists in database' if find(entity)

        db_spot = Database::SpotOrm.create(entity.to_attr_hash)
        entity.reports.map do |report|
          db_report = Database::ReportOrm.create(report.to_attr_hash)
          db_spot.add_report(db_report)
        end
        rebuild_entity(db_spot)
      end
    end
  end
end
