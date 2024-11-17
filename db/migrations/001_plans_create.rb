# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:plans) do
      primary_key :id

      Float   :score
      String  :type

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
