# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:spots) do
      primary_key :id

      String :place_id, unique: true
      String :formatted_address
      String :display_name
      Float  :rating
      String :reviews # Store json

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
