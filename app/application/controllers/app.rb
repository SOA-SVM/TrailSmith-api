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

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end
      # routing.on 'api/v1' do
      #   routing.on 'plans' do
      #     # routing.on String do |plan_id|
      #     #   # POST /plans/{plan_id}
      #     #   routing.get do
      #     #     result
      #     #   end
      #     # end

      #     routing.is do
      #       # GET /plans?list={base64_json_array_of_plan_ids}
      #       routing.get do
      #         list_req = Request::EncodedPlanList.new(routing.params)
      #         result = Service::ListPlans.new.call(list_request: list_req)

      #         if result.failure?
      #           failed = Representer::HttpResponse.new(result.failure)
      #           routing.halt failed.http_status_code, failed.to_json
      #         end

      #         http_response = Representer::HttpResponse.new(result.value!)
      #         response.status = http_response.http_status_code
      #         Representer::PlansList.new(result.value!.message).to_json
      #       end
      #     end
      #   end
      #   # routing.on 'plan' do
      #   #   routing.is do
      #   #     # POST /plan/
      #   #     routing.post do
      #   #       location_made = Forms::NewLocation.new.call(routing.params)
      #   #       result = Service::CreateLocation.new.call(location_made.to_h)

      #   #       if result.failure?
      #   #         flash[:error] = result.failure
      #   #         routing.redirect '/'
      #   #       end

      #   #       plan = result.value!
      #   #       session[:watching].insert(0, plan.id).uniq!
      #   #       flash[:notice] = MSG_PLAN_CREATED
      #   #       routing.redirect "plan/#{plan.id}"
      #   #     end
      #   #   end

      #   #   routing.on String do |plan_id|
      #   #     # DELETE /plan/[plan_id]
      #   #     routing.delete do
      #   #       session[:watching].delete(plan_id.to_i)
      #   #       routing.redirect '/'
      #   #     end

      #   #     # GET /plan/[plan_id]
      #   #     routing.get do
      #   #       result = Service::FindPlan.new.call(plan_id)

      #   #       if result.failure?
      #   #         flash[:error] = result.failure
      #   #         routing.redirect '/'
      #   #       else
      #   #         plan = result.value!
      #   #         viewable_plan = Views::PlanView.new(plan)
      #   #         viewable_map = Views::Map.new(plan)
      #   #       end

      #   #       view 'plan',
      #   #            locals: { plan: viewable_plan, map: viewable_map }
      #   #     end
      #   #   end
      #   # end

      #   # routing.on 'proxy' do
      #   #   routing.is 'google_maps.js' do
      #   #     response['Content-Type'] = 'application/javascript'
      #   #     api_key = App.config.GOOGLE_MAPS_KEY

      #   #     result = Service::GoogleMapsProxy.new.call(api_key)

      #   #     if result.success?
      #   #       response.write(result.value!)
      #   #     else
      #   #       response.status = 500
      #   #       response.write("console.error('#{result.failure}')")
      #   #     end
      #   #   end
      #   # end
      # end
    end
  end
end
