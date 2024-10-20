# frozen_string_literal: true

<<<<<<< HEAD
require_relative 'require_app'
require_app

run TrailSmith::App.freeze.app
=======
require 'bundler/setup'  # Make sure this line is present
require './app/controllers/app'  # Adjust if your path is different

run TrailSmith::App
>>>>>>> d9baf78... Initial commit
