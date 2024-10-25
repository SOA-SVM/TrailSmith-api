# frozen_string_literal: true

source 'https://rubygems.org'

# Configuration and Utilities
gem 'figaro', '~> 1.0'
gem 'pry', '~> 0.14.2'
gem 'rake', '~> 13.2', '>= 13.2.1'

# Web Application
gem 'logger', '~> 1.6', '>= 1.6.1'
gem 'puma', '~> 6.4', '>= 6.4.3'
gem 'roda', '~> 3.85'
gem 'slim', '~> 5.2', '>= 5.2.1'

# Data Validation
gem 'dry-struct', '~> 1.6'
gem 'dry-types', '~> 1.7', '>= 1.7.2'

# Networking
gem 'http', '~> 5.2'

# Database
gem 'hirb'
# gem 'hirb-unicode' # incompatible with new rubocop
gem 'sequel', '~> 5.0'

group :development, :test do
  gem 'sqlite3', '~> 1.0'
end

# Testing
group :test do
  gem 'minitest', '~> 5.20'
  gem 'minitest-rg', '~> 5.2'
  gem 'simplecov', '~> 0.22.0'
  gem 'vcr', '~> 6.3', '>= 6.3.1'
  gem 'webmock', '~> 3.24'
end

# Development
group :development do
  gem 'flog', '~> 4.8'
  gem 'reek', '~> 6.3'
  gem 'rerun', '~> 0.14.0'
  gem 'rubocop', '~> 1.66', '>= 1.66.1'
  gem 'rubocop-minitest', '~> 0.36.0'
  gem 'rubocop-rake', '~> 0.6.0'
  gem 'rubocop-sequel'
end
