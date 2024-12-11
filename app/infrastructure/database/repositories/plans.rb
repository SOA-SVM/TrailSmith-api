# frozen_string_literal: true

require 'json'

module TrailSmith
  module Repository
    # Repository for Reports
    class Plans
      def self.all
        Database::PlanOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        # find database of entity from id
        db_record = Database::PlanOrm.find(entity.id)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        # build entity from database
        return nil unless db_record

        Entity::Plan.new(db_record.to_hash)
      end

      def self.create(entity)
        raise 'Entity already exists in database' if find(entity)

        db_record = Database::PlanOrm.create(entity.to_attr_hash)
        rebuild_entity(db_record)
      end
    end
  end
end
