# frozen_string_literal: true

require 'json'

module TrailSmith
  module Repository
    # Repository for Members
    class Spots
      def self.all
        Database::SpotOrm.all.map { |db_spot| rebuild_entity(db_spot) }
      end

      def self.find_id(id)
        rebuild_entity Database::SpotOrm.find(id: id)
      end

      def self.find_place_id(place_id)
        rebuild_entity Database::SpotOrm.find(place_id: place_id)
      end

      def self.find_display_name(display_name)
        rebuild_entity Database::SpotOrm.find(display_name: display_name)
      end

      def self.create(entity)
        place_id = entity.place_id
        record = Database::SpotOrm.where(place_id: place_id).first

        return if record

        spot_orm = Database::SpotOrm.create(place_id: place_id,
                                            formatted_address: entity.formatted_address,
                                            display_name: entity.display_name,
                                            rating: entity.rating,
                                            reviews: entity.reviews.to_json)
        rebuild_entity(spot_orm)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Spot.new(
          id: db_record.id,
          place_id: db_record.place_id,
          formatted_address: db_record.formatted_address,
          display_name: db_record.display_name,
          rating: db_record.rating,
          reviews: JSON.parse(db_record.reviews, symbolize_names: true)
        )
      end
    end
  end
end
