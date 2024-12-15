#  frozen_string_literal: true

module Views
  # View for a list of plan entities
  class PlansList
    def initialize(plans)
      @plans = plans.map.with_index do |plan, index|
        Plan.new(plan, index)
      end
    end

    def each(&show)
      @plans.each do |plan|
        show.call plan
      end
    end

    def any?
      @plans.any?
    end
  end
end
