#  frozen_string_literal: true

require 'dry/monads'

module TrailSmith
  module Service
    # Service to find a specific plan
    class FindPlan
      include Dry::Monads::Result::Mixin

      def call(plan_id)
        plan = Repository::For.klass(Entity::Plan).find_id(plan_id)
        plan ? Success(plan) : Failure('Could not find the plan.')
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
