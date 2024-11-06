# frozen_string_literal: true

require 'json'

module TrailSmith
  module Repository
    # Repository for Members
    class Plans
      def self.find_id(id)
        rebuild_entity Database::PlanOrm.find(id: id)
      end
    end
  end
end
