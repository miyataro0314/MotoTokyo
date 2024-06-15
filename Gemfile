source 'https://rubygems.org'

ruby '3.3.0'

# Core Rails gems
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'sprockets-rails'
gem "pg", "~> 1.1"
gem 'puma', '>= 5.0'
gem 'jbuilder'

# JavaScript and CSS Bundling
gem 'jsbundling-rails'
gem 'cssbundling-rails'

# Hotwire (Turbo and Stimulus)
gem 'turbo-rails'
gem 'stimulus-rails'

# Redis
# gem "redis", ">= 4.0.1"
# gem "kredis"

# Authentication
gem 'devise'

# Geospatial data
gem 'activerecord-postgis-adapter', '~> 9.0'

# Pagination
gem 'kaminari'

# HTTP Client
gem 'http'

# Schedule
gem 'whenever', require: false

# Sitemap generation
gem 'sitemap_generator'

# Image processing
gem "image_processing", "~> 1.2"

# X(Twitter) API
gem 'x'

# Time zone data for Windows
gem 'tzinfo-data', platforms: %i[ windows jruby ]

# Performance
gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener_web'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
end

group :production do
  gem 'aws-sdk-s3'
end