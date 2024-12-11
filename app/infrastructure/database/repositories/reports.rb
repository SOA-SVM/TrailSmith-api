# frozen_string_literal: true

require 'json'

module TrailSmith
  module Repository
    # Repository for Reports
    class Reports
      def self.all
        Database::ReportOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        # find database of entity from id
        db_record = Database::ReportOrm.find(text: entity.text)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        # build entity from database
        return nil unless db_record

        Entity::Report.new(db_record.to_hash)
      end

      def self.create(entity)
        raise 'Entity already exists in database' if find(entity)

        db_record = Database::ReportOrm.create(entity.to_attr_hash)
        rebuild_entity(db_record)
      end
    end
  end
end
