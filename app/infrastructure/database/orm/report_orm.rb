# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Spot Entities
    class ReportOrm < Sequel::Model(:reports)
      many_to_one :reports_of_spot,
                  class: :'TrailSmith::Database::SpotOrm',
                  join_table: :reports_spots,
                  left_key: :report_id, right_key: :spot_id

      plugin :timestamps, update_on_create: true
    end
  end
end
