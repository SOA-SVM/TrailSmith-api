# frozen_string_literal: true

require 'json'

module TrailSmith
  module Repository
    # Repository for Members
    class Spots
      # def self.all
      #   Database::SpotOrm.all.map { |db_spot| rebuild_entity(db_spot) }
      # end

      def self.find(entity)
        # find database of entity from place_id
        find_place_id(entity.place_id)
      end

      def self.find_place_id(id)
        # find database from place_id
        db_record = TrailSmith::Database::SpotOrm.find(id:)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        # build entity from database
        return nil unless db_record

        TrailSmith::Entity::Spot.new(db_record.to_hash)
      end

      def self.create(entity)
        raise 'Entity already exists in database' if find(entity)

        db_record = TrailSmith::Database::SpotOrm.create(entity.to_attr_hash)
        db_record.reports = entity.reports.to_json
        rebuild_entity(db_record)
      end
    end
  end
end
