#  frozen_string_literal: true

require 'dry/transaction'

module TrailSmith
  module Service
    # Retrieves array of all listed plan entities
    class ListPlans
      include Dry::Transaction

      step :validate_list
      step :retrieve_plans

      private

      DB_ERR = 'Could not access database'

      # Expects list of plans in input[:list_request]
      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def retrieve_plans(input)
        Repository::For.klass(Entity::Plan).find_ids(input[:list])
          .then { |plans| Response::PlansList.new(plans) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR)
        )
      end
    end
  end
end
