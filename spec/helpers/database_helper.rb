# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    db = TrailSmith::App.db
    # Ignore foreign key constraints when wiping tables
    db.run('PRAGMA foreign_keys = OFF')
    TrailSmith::Database::TripOrm.map(&:destroy)
    db.run('PRAGMA foreign_keys = ON')
  end
end
