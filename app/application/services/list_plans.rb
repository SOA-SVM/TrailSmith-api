#  frozen_string_literal: true

require 'dry/monads'

module TrailSmith
  module Service
    # Retrieves array of all listed plan entities
    class ListPlans
      include Dry::Monads::Result::Mixin

      def call(plans_list)
        plans = Repository::For.klass(Entity::Plan)
          .find_ids(plans_list)

        Success(plans)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
