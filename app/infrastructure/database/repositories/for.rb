# frozen_string_literal: true

require_relative 'spots'
require_relative 'plans'
require_relative 'reports'
require_relative 'routes'

module TrailSmith
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::Spot   => Spots,
        Entity::Plan   => Plans,
        Entity::Report => Reports,
        Value::Route   => Routes
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
