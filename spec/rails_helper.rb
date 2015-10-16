# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'websocket_rails/spec_helpers'
require 'simplecov'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist

SimpleCov.start 'rails'
SimpleCov.minimum_coverage 90

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include SessionHelper
  config.include RequestHelper, type: :request
  config.include FeatureHelper, type: :feature

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
end
