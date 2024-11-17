# frozen_string_literal: true

module TrailSmith
  module Repository
    # Repository for Members
    class Plans
      def self.create(entity)
        plan_orm = Database::SpotOrm.create(type: entity.type,
                                            score: entity.score)
        rebuild_entity(plan_orm)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Plan.new(
          id: db_record.id,
          type: db_record.type,
          score: db_record.score
        )
      end
    end
  end
end
