#  frozen_string_literal: true

module Views
  # View for drawing map information
  class Map
    def initialize(plan)
      @plan = Plan.new(plan)
    end

    def polylines
      @plan.polylines.to_json
    end

    def locations
      @plan.locations.to_json
    end
  end
end
