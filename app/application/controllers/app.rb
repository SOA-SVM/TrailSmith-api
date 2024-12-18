# frozen_string_literal: true

require 'rack'
require 'roda'
require 'erb'
require 'json'

module TrailSmith
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "TrailSmith API v1 at /api/v1/ in #{App.enviroment} mode"

        list_result = Service::ListPlans.new.call(session[:watching])

        if list_result.failure?
          flash[:error] = list_result.failure
          viewable_plans = []
        else
          plans = list_result.value!
          flash.now[:notice] = MSG_GET_STARTED if plans.none?

          session[:watching] = plans.map(&:id)
          viewable_plans = Views::PlansList.new(plans)
        end

        view 'home', locals: { plans: viewable_plans }
      end

      routing.on 'plan' do
        routing.is do
          # POST /plan/
          routing.post do
            location_made = Forms::NewLocation.new.call(routing.params)
            result = Service::CreateLocation.new.call(location_made.to_h)

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            plan = result.value!
            session[:watching].insert(0, plan.id).uniq!
            flash[:notice] = MSG_PLAN_CREATED
            routing.redirect "plan/#{plan.id}"
          end
        end

        routing.on String do |plan_id|
          # DELETE /plan/[plan_id]
          routing.delete do
            session[:watching].delete(plan_id.to_i)
            routing.redirect '/'
          end

          # GET /plan/[plan_id]
          routing.get do
            result = Service::FindPlan.new.call(plan_id)

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            else
              plan = result.value!
              viewable_plan = Views::PlanView.new(plan)
              viewable_map = Views::Map.new(plan)
            end

            view 'plan',
                 locals: { plan: viewable_plan, map: viewable_map }
          end
        end
      end

      routing.on 'proxy' do
        routing.is 'google_maps.js' do
          response['Content-Type'] = 'application/javascript'
          api_key = App.config.GOOGLE_MAPS_KEY

          result = Service::GoogleMapsProxy.new.call('bad_token')

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
