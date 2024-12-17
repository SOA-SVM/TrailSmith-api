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
      ('A'.ord + @index).chr
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

    def each_hashtag(&show)
      @spot.keywords.sample(3).each do |hashtag|
        show.call "# #{hashtag}"
      end
    end
  end

  # View for spot's popular
  class ScoreRank
    def initialize(score_rank)
      @score_rank = score_rank
    end

    def to_css_class
      if @score_rank.not_available?
        'secondary'
      elsif @score_rank.high?
        'success'
      elsif @score_rank.medium?
        'warning'
      elsif @score_rank.low?
        'danger'
      end
    end

    def to_css_class_reverse
      if @score_rank.not_available?
        'secondary'
      elsif @score_rank.high?
        'danger'
      elsif @score_rank.medium?
        'warning'
      elsif @score_rank.low?
        'success'
      end
    end
  end
end
