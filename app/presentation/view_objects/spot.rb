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
      ScoreRank.new(@spot.popular).to_css_class
    end

    def how_fun?
      ScoreRank.new(@spot.fun).to_css_class
    end

    # def how_relax?
    #   Score.new(@spot.relax)
    # end
  end

  # View for spot's popular
  class ScoreRank
    def initialize(score_rank)
      @score_rank = score_rank
    end

    def to_css_class
      if @score_rank.not_available?
        'bg-secondary'
      elsif @score_rank.high?
        'bg-success'
      elsif @score_rank.medium?
        'bg-warning'
      elsif @score_rank.low?
        'bg-danger'
      end
    end
  end
end
