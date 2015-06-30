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

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Requests::JsonHelpers, type: :request

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
end
