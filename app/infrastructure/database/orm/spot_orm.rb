# frozen_string_literal: true

require 'sequel'

module TrailSmith
  module Database
    # Object Relational Mapper for Project Entities
    class SpotOrm < Sequel::Model(:spot)
      plugin :timestamps, update_on_create: true
    end
  end
end
