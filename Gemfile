# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# CONFIGURATION
gem 'figaro', '~> 1.2'
gem 'pry'
gem 'rack-test'
gem 'rake', '~> 13.2', '>= 13.2.1'

# PRESENTATION LAYER
gem 'multi_json', '~> 1.15'
gem 'ostruct', '~> 0.6.1'
gem 'roar', '~> 1.2'

# APPLICATION LAYER
# Web application related
gem 'logger', '~> 1.6', '>= 1.6.1'
gem 'puma', '~> 6.4', '>= 6.4.3'
gem 'rack-session', '~> 2.0'
gem 'roda', '~> 3.85'
gem 'tilt'

# Controllers and services
gem 'dry-monads', '~> 1.6'
gem 'dry-transaction', '~> 0.16.0'
gem 'dry-validation', '~> 1.10'

# Caching
gem 'rack-cache', '~> 1.17'
gem 'redis', '~> 5.3'
gem 'redis-rack-cache', '~> 2.2', '>= 2.2.1'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1.6'
gem 'dry-types', '~> 1.7', '>= 1.7.2'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5.2'

# Database
gem 'hirb'
# gem 'hirb-unicode' # incompatible with new rubocop
gem 'sequel', '~> 5.0'

# Asynchronicity
gem 'concurrent-ruby', '~> 1.3', '>= 1.3.4'
gem 'aws-sdk-sqs', '~> 1.89'
gem 'shoryuken', '~> 6.2', '>= 6.2.1'

group :development, :test do
  gem 'sqlite3', '~> 1.0'
end

group :production do
  gem 'pg', '~> 1.5', '>= 1.5.9'
end

# Testing
group :test do
  # API Unit/Integration/Acceptance Tests
  gem 'minitest', '~> 5.20'
  gem 'minitest-rg', '~> 5.2'
  gem 'simplecov', '~> 0.22.0'
  gem 'vcr', '~> 6.3', '>= 6.3.1'
  gem 'webmock', '~> 3.24'
end

# Development
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-rake'
  gem 'rubocop-sequel'
end

gem 'rackup', '~> 2.2'
gem 'sinatra'

# API
gem 'google-maps', '~> 3.0', '>= 3.0.7'

# Others
gem 'mutex_m'
