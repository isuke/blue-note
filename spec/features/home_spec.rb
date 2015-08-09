require 'rails_helper'

RSpec.feature 'Home Page', js: true do
  background { visit home_path }

  subject { page }

  scenario 'show' do
    expect(page).to have_selector 'h1', text: 'Blue Note'
  end
end
