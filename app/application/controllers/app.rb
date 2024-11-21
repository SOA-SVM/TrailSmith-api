#  frozen_string_literal: true

require 'rack' # for Rack::MethodOverride
require 'roda'
require 'erb'
require 'irb'

module TrailSmith
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'erb', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    # Load CSS assets with a timestamp to prevent caching issues
    plugin :assets, path: 'app/presentation/assets', css: 'style.css', timestamp_paths: true
    plugin :common_logger, $stderr

    MESSAGES = {
      invalid_location: 'Invalid location input.',
      location_not_found: 'Could not find that location.',
      db_error: 'Database error occurred.'
    }.freeze

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        spots = Repository::For.klass(Entity::Spot).all
        view 'home', locals: { spots: }
      end

      routing.on 'location' do
        routing.is do
          # POST /location/
          routing.post do
            query = routing.params['query'].downcase
            if query.nil? || query.empty?
              flash[:error] = MESSAGES[:invalid_location]
              response.status = 400
              routing.redirect '/'
            end

            begin
              spot = GoogleMaps::SpotMapper.new(App.config.GOOGLE_MAPS_KEY).find(query)
              Repository::For.entity(spot).create(spot)
              routing.redirect "location/#{spot.place_id}"
            rescue StandardError => err
              App.logger.error "ERROR: #{err.message}"
              flash[:error] = MESSAGES[:location_not_found]
              routing.redirect '/'
            end
          end
        end

        routing.on String do |place_id|
          # GET /location/[place_id]
          routing.get do
            begin
              spot = Repository::For.klass(Entity::Spot).find_place_id(place_id)
              if spot.nil?
                flash[:error] = MESSAGES[:location_not_found]
                # routing.redirect '/'
              end
            rescue StandardError => err
              App.logger.error "ERROR: #{err.message}"
              flash[:error] = MESSAGES[:db_error]
              routing.redirect '/'
            end

            view 'location', locals: { spot: spot }
          end
        end
      end
    end
  end
end
