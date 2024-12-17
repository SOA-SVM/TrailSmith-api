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

    def distance(spot)
      "distance: #{@plan.routes[spot.index].distance_desc}"
    end

    def duration(spot)
      "duration: #{@plan.routes[spot.index].travel_time_desc}"
    end

    def how_relax?(spot)
      ScoreRank.new(@plan.routes[spot.index].tiredness).to_css_class_reverse
    end

    def tiredness(spot)
      @plan.routes[spot.index].tiredness.value
    end

    def origin_json
      {
        num_people: @plan.num_people,
        region: @plan.region,
        day: @plan.day,
        spots: @spots.map(&:name),
        mode: @plan.routes.map(&:travel_mode)
      }.to_json
    end
  end
end
