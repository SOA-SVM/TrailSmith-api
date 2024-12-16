#  frozen_string_literal: true

module Views
  # View for a single spot entity
  class Spot
    attr_reader :index

    def initialize(spot, index = nil)
      @spot = spot
      @index = index
    end

    def address
      @spot.address
    end

    def step_index
      @index + 1
    end

    def name
      @spot.name
    end

    def how_popular?
      Popular.new(@spot.popular).to_css_class
    end
  end

  # View for spot's popular
  class Popular
    def initialize(popularity)
      @popularity = popularity
    end

    def to_css_class
      if @popularity.high?
        'bg-success'
      elsif @popularity.medium?
        'bg-warning'
      elsif @popularity.low?
        'bg-danger'
      end
    end
  end
end
