# frozen_string_literal: true

module TrailSmith
    module Service
      class ViewLocation
        include Dry::Monads[:result]
  
        def call(plan_id)
          plan = Repository::For.klass(Entity::Plan).find_id(plan_id)
          return Failure('Plan not found') if plan.nil?
  
          Success(
            plan: plan,
            hashtag: build_hashtag(plan),
            locations: build_locations(plan),
            polylines: build_polylines(plan)
          )
        rescue StandardError
          Failure('Could not access database')
        end
  
        private
  
        def build_hashtag(plan)
          {
            people: plan.num_people,
            region: plan.region,
            day: plan.day
          }
        end
  
        def build_locations(plan)
          plan.spots.map do |spot|
            {
              'coordinate' => spot.coordinate.to_h,
              'title' => spot.name
            }
          end.to_json
        end
  
        def build_polylines(plan)
          plan.routes.map(&:overview_polyline).to_json
        end
      end
    end
  end