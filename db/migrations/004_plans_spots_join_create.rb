# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:plans_spots) do
      primary_key [:plan_id, :spot_id] # rubocop:disable Style/SymbolArray
      foreign_key :plan_id, :plans
      foreign_key :spot_id, :spots

      index [:plan_id, :spot_id] # rubocop:disable Style/SymbolArray
    end
  end
end
