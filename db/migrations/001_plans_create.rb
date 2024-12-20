# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:plans) do
      primary_key :id

      String   :region
      Integer  :num_people
      Integer  :day

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
