# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'pry'
gem 'rake', '~> 13.2', '>= 13.2.1'

# Web Application
gem 'erb', '~> 4.0', '>= 4.0.4'
gem 'htmlbeautifier'
gem 'logger', '~> 1.6', '>= 1.6.1'
gem 'puma', '~> 6.4', '>= 6.4.3'
gem 'rack-session', '~> 2.0'
gem 'roda', '~> 3.85'
gem 'tilt'

group :production do
  gem 'pg', '~> 1.5', '>= 1.5.9'
end

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

  # gem 'headless', '~> 2.3', '>= 2.3.1'
  # gem 'selenium-webdriver', '~> 4.26'
  # gem 'watir', '~> 7.3'
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
