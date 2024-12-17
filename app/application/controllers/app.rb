# frozen_string_literal: true

require 'rack'
require 'roda'
require 'erb'
require 'json'

module TrailSmith
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :render, engine: 'erb', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                   css: 'style.css', timestamp_paths: true,
                   js: 'table_row_click.js'
    plugin :common_logger, $stderr

    use Rack::MethodOverride

    MESSAGES = {
      invalid_location: 'Invalid location input.',
      location_not_found: 'Could not find that location.',
      plan_not_found: 'Could not find the plan.',
      db_error: 'Database error occurred.',
      no_plan: 'Add a spot to get started.',
      no_recommendation: 'No recommendations available.'
    }.freeze

    MSG_GET_STARTED = 'Add a plan to get started.'

    route do |routing|
      routing.assets
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        session[:watching] ||= []
        
        result = Service::ListPlans.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_plans = []
        else
          plans = result.value!
          flash.now[:notice] = MSG_GET_STARTED if plans.none?

          session[:watching] = plans.map(&:id)
          viewable_plans = Views::PlansList.new(plans)
        end

        view 'home', locals: { plans: viewable_plans }
      end

      routing.on 'location' do
        routing.is do
          # POST /location/
          routing.post do
            # 使用 Form Object 驗證輸入
            location_made = Forms::NewLocation.new.call(routing.params)
            if location_made.failure?
              flash[:error] = MESSAGES[:invalid_location]
              routing.redirect '/'
            end

            # 使用 Service Object 處理 OpenAI 和 Google Maps 邏輯
            result = Service::CreateLocation.new.call(location_made.to_h)
            
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            plan = result.value!
            session[:watching].insert(0, plan.id).uniq!
            flash[:notice] = 'Location created successfully'
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
            result = Service::ViewLocation.new.call(plan_id)
            
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            view_data = result.value!
            view 'location', locals: view_data

          rescue StandardError => e
            App.logger.error "ERROR: #{e.message}"
            flash[:error] = MESSAGES[:db_error]
            routing.redirect '/'
          end
        end
      end

      routing.on 'proxy' do
        routing.is 'google_maps.js' do
          response['Content-Type'] = 'application/javascript'
          api_key = App.config.GOOGLE_MAPS_KEY

          result = Service::GoogleMapsProxy.new.fetch_map_script(api_key)

          if result.success?
            response.write(result.value!)
          else
            response.status = 500
            response.write("console.error('#{result.failure}')")
          end
        end
      end
    end
  end
end