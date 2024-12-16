# frozen_string_literal: true

require 'json'

module TrailSmith
  module Repository
    # Repository for Reports
    class Routes
      def self.all
        Database::RouteOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        db_record = Database::RouteOrm.find(starting_spot: entity.starting_spot,
                                            next_spot: entity.next_spot)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Value::Route.new(db_record.to_hash)
      end

      def self.create(entity)
        raise 'Route Entity already exists in database' if find(entity)

        db_record = Database::RouteOrm.create(entity.to_attr_hash)
        rebuild_entity(db_record)
      end
    end
  end
end
