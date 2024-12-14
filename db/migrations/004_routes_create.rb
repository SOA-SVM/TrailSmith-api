# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:routes) do
      primary_key :id
      foreign_key :plan_id, :plans

      String  :starting_spot
      String  :next_spot
      String  :travel_mode
      Integer :travel_time
      String  :travel_time_desc
      Integer :distance
      String  :distance_desc
      String  :overview_polyline

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
