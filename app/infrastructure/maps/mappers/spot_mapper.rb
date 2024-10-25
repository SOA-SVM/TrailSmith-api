# frozen_string_literal: false

module TrailSmith
  module GoogleMaps
    # Data Mapper: Maps place -> Spot entity
    class SpotMapper
      def initialize(key, gateway_class = GoogleMaps::Api)
        @key = key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def find(text_query)
        data = @gateway.place_data(text_query)
        SpotMapper.build_entity(data)
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Parsing review
      class Review
        def initialize(review_data)
          @author_name = review_data['authorAttribution']['displayName']
          @rating = review_data['rating'].to_f
          @text = review_data['originalText']['text']
        end

        def to_h
          {
            author_name: @author_name,
            rating: @rating,
            text: @text
          }
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          TrailSmith::Entity::Spot.new(
            id: nil,
            place_id:,
            formatted_address:,
            display_name:,
            rating:,
            reviews:
          )
        end

        def place_id
          @data['places'][0]['id']
        end

        def formatted_address
          @data['places'][0]['formattedAddress']
        end

        def display_name
          @data['places'][0]['displayName']['text']
        end

        def rating
          @data['places'][0]['rating'].to_f
        end

        def reviews
          @data['places'][0]['reviews'].map do |review|
            Review.new(review).to_h
          end
        end
      end
    end
  end
end
