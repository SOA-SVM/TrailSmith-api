# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Spot Entities
    class ReportOrm < Sequel::Model(:reports)
      many_to_one :spot,
                  class: :'TrailSmith::Database::SpotOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
