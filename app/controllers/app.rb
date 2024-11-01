#  frozen_string_literal: true

require 'roda'
require 'slim'

module TrailSmith
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'location' do
        routing.is do
          # POST /location/
          routing.post do
            query = routing.params['query'].downcase
            spot = GoogleMaps::SpotMapper.new(App.config.GOOGLE_MAPS_KEY).find(query)
            Repository::For.entity(spot).create(spot)
            routing.redirect "location/#{spot.place_id}"
          end
        end

        routing.on String do |place_id|
          # GET /location/[place_id]
          routing.get do
            spot = Repository::For.klass(Entity::Spot).find_place_id(place_id)
            view 'location', locals: { spot: spot }
          end
        end
      end
    end
  end
end
