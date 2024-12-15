#  frozen_string_literal: true

module Views
  # View for a single plan entity
  class Plan
    def initialize(plan, index = nil)
      @plan = plan
      @index = index
    end

    def plan_link
      "location/#{@plan.id}"
    end

    def index_str
      "plan[#{@index}]"
    end

    def plan_title
      "Trip to #{@plan.region}"
    end

    def day
      @plan.day
    end

    def num_people
      @plan.num_people
    end

    def spot_names
      @plan.spots.map(&:name).join(', ')
    end
  end
end
