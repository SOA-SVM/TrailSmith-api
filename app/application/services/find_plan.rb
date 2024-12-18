#  frozen_string_literal: true

require 'dry/transaction'

module TrailSmith
  module Service
    # Service to find a specific plan
    class FindPlan
      include Dry::Transaction

      step :find_plan

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      DB_NOT_FOUND_MSG = 'Could not find that plan'

      def find_plan(input)
        plan = Repository::For.klass(Entity::Plan).find_id(input[:plan_id])
        if plan
          Success(Response::ApiResult.new(status: :created, message: input.merge(plan: plan)))
        else
          Failure(Response::ApiResult.new(status: :not_found, message: DB_NOT_FOUND_MSG))
        end
      rescue StandardError => err
        Failure(Response::ApiResult.new(status: :not_found, message: err.to_s))
      end
    end
  end
end
