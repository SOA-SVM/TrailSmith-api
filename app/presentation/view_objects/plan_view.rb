#  frozen_string_literal: true

module Views
  # View for a plan entites in location page
  class PlanView
    def initialize(plan)
      @plan = Plan.new(plan)
      @spots = plan.spots.map.with_index do |spot, index|
        Spot.new(spot, index)
      end
    end

    def each_spot(&show)
      @spots.each do |spot|
        show.call spot
      end
    end

    def title_name
      "A Trip to #{@plan.region}"
    end

    def title_day
      "Day: #{@plan.day}"
    end

    def title_people
      "People: #{@plan.num_people}"
    end

    def not_last_spot?(spot)
      spot.index < @spots.size - 1
    end

    def travel_mode(spot)
      "travel mode: #{@plan.routes[spot.index].travel_mode}"
    end
  end
end
