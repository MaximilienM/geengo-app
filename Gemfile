source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'jquery-rails'
gem "devise", "~> 1.4.3"
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem "carrierwave"
gem "cancan"
gem "airbrake"
gem "rails-i18n"
gem "nokogiri"
gem "mini_magick"
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git'
gem 'bootstrap-sass', '~> 1.4.0'
gem "ancestry"
gem "resque", :require => "resque/server"
gem "geocoder"
gem "gmaps4rails"
gem "kaminari"
gem "best_in_place"

gem "importer", :git => "git://github.com/CruxConsulting/importer.git", :ref => "5fa5f7f"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :test do
  gem "guard-rspec"
  gem "factory_girl", "~> 2.0.4"
  gem 'spork', '~> 0.9.0.rc'
  gem "guard-spork"
  gem "capybara"
  gem "remarkable_activerecord", "~> 4.0.0.alpha4"
end

group :test, :development do
  gem "rspec-rails", "~> 2.4"
end

group :production, :staging, :qa do
  gem "fog"
  gem 'unicorn'
  gem "hirefire", :git => "git://github.com/CruxConsulting/hirefire.git", :branch => "cedar"
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development do
  gem 'ruby-debug19', :require => 'ruby-debug'
end