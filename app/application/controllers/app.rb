#  frozen_string_literal: true

require 'rack' # for Rack::MethodOverride
require 'roda'
require 'erb'
require 'irb'
require 'json'

module TrailSmith
  # Web App
  class App < Roda # rubocop:disable Metrics/ClassLength
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'erb', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    # Load CSS assets with a timestamp to prevent caching issues
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', timestamp_paths: true,
                    js: 'table_row_click.js'
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    MESSAGES = {
      invalid_location: 'Invalid location input.',
      location_not_found: 'Could not find that location.',
      plan_not_found: 'Could not find the plan.',
      db_error: 'Database error occurred.',
      no_plan: 'Add a spot to get started.',
      no_recommendation: 'No recommendations available.'
    }.freeze

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []
        plans = Repository::For.klass(Entity::Plan).find_ids(session[:watching])
        session[:watching] = plans.map(&:id)
        flash.now[:notice] = MESSAGES[:no_plan] if plans.none?
        view 'home', locals: { plans: }
      end

      routing.on 'location' do
        routing.is do
          # POST /location/
          routing.post do
            query = routing.params['query']
            if query.nil? || query.empty?
              flash[:error] = MESSAGES[:invalid_location]
              response.status = 400
              routing.redirect '/'
            end

            begin
              puts "\n=== OpenAI API 呼叫開始 ==="
              puts '已建立 OpenAI Mapper'

              prompt = <<~PROMPT
                Generates travel itineraries based on location: #{query}

                Required JSON format:
                {
                  "num_people": Integer (default: 2),
                  "region": String (location area/city),
                  "day": Integer (default: 1),
                  "spots": Array[String] (min 2, recommended 4 spots),
                  "mode": Array[String] (length = spots.length - 1)
                }

                Rules:
                1. mode must be from: ["walking", "driving", "bicycling", "transit"]
                2. number of mode elements must be exactly (spots.length - 1)
                3. customize to location characteristics
                4. spots should be actual tourist attractions/destinations
                5. return ONLY the JSON object, no additional text

                Example structure (DO NOT use these values, generate based on #{query}):
                {
                  "num_people": 2,
                  "region": "Kyoto",
                  "day": 1,
                  "spots": [
                    "Kinkaku-ji",
                    "Arashiyama Bamboo Grove",
                    "Fushimi Inari Shrine",
                    "Nijo Castle"
                  ],
                  "mode": ["walking", "transit", "walking"]
                }
              PROMPT
              puts "Prompt: #{prompt}"

              wish_result = Openai::OpenaiMapper.new(App.config.OPENAI_TOKEN)
                .find(prompt, model: 'gpt-4o-mini', max_tokens: 500)

              puts "API complete response: #{wish_result.inspect}"

              if wish_result&.messages&.any?
                raw_response = wish_result.messages.first
                puts "Raw response: #{raw_response}"

                begin
                  # 嘗試解析 JSON 並確保必要的欄位存在
                  parsed_json = JSON.parse(raw_response)
                  required_fields = %w[num_people region day spots mode]

                  if required_fields.all? { |field| parsed_json.key?(field) }
                    session[:last_wish] = raw_response
                    puts 'Successfully stored JSON in session'
                  else
                    puts 'Missing required fields in JSON response'
                    session[:last_wish] = 'Error: Invalid response format'
                  end
                rescue JSON::ParserError => err
                  puts "JSON parsing error: #{err.message}"
                  session[:last_wish] = raw_response
                end
              else
                puts 'No valid response received from API'
                flash[:error] = MESSAGES[:no_recommendation]
              end
              puts '=== OpenAI API 呼叫結束 ==='
            rescue StandardError => err
              puts "\n=== 發生錯誤 ==="
              puts "錯誤類型: #{err.class}"
              puts "錯誤訊息: #{err.message}"
              puts "錯誤堆疊:\n#{err.backtrace.join("\n")}"
              App.logger.error "OpenAI ERROR: #{err.message}"
              session[:last_wish] = 'Error: Unable to generate recommendations'
            end

            begin
              plan = GoogleMaps::PlanMapper.new(App.config.GOOGLE_MAPS_KEY).build_entity(raw_response)
              plan = Repository::For.entity(plan).create(plan)
            rescue StandardError => err
              App.logger.error "ERROR: #{err.message}"
              flash[:error] = MESSAGES[:location_not_found]
              routing.redirect '/'
            end

            # Add new project to watched set in cookies
            session[:watching].insert(0, plan.id).uniq!

            routing.redirect "location/#{plan.id}"
          end
        end

        routing.on String do |plan_id|
          # DELETE /location/[plan_id]
          routing.delete do
            session[:watching].delete(plan_id.to_i)

            routing.redirect '/'
          end

          # GET /location/[plan_id]
          routing.get do
            begin
              plan = Repository::For.klass(Entity::Plan).find_id(plan_id)
              if plan.nil?
                flash[:error] = MESSAGES[:plan_not_found]
                # routing.redirect '/'
              end
            rescue StandardError => err
              App.logger.error "ERROR: #{err.message}"
              flash[:error] = MESSAGES[:db_error]
              routing.redirect '/'
            end

            hashtag = {
              people: plan.num_people,
              region: plan.region,
              day: plan.day
            }

            locations = plan.spots.map do |spot|
              {
                'coordinate' => spot.coordinate.to_h,
                'title'      => spot.name
              }
            end.to_json

            polylines = plan.routes.map(&:overview_polyline).to_json

            view 'location', locals: { plan:, locations:, polylines:, hashtag: }
          end
        end
      end

      routing.on 'proxy' do
        routing.is 'google_maps.js' do
          response['Content-Type'] = 'application/javascript'
          api_key = App.config.GOOGLE_MAPS_KEY
          response.write(GoogleMapsProxy.fetch_map_script(api_key))
        end
      end
    end
  end
end
