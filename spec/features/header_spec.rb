require 'rails_helper'

RSpec.feature 'Header', js: true do
  background { visit home_path }

  subject { page.find('.header') }

  context 'for NOT login user' do
    scenario 'show' do
      expect(find('.header')).to have_content 'Login'
    end
  end

  context 'for login user' do
    given!(:projects) { create_list(:project, 3) }
    given!(:user) { create(:user, :with_projects, name: 'Alice', email: 'alice@example.com', password: 'foobar', projects: projects) }

    background do
      login user, with_capybara: true
      visit home_path
    end

    scenario 'show' do
      expect(find('.header')).to have_content 'Dashboard'
      expect(find('.header')).to have_content 'Projects'
      expect(find('.header')).to have_content user.name
      expect(find('.header')).not_to have_content 'Login'
    end

    scenario "show projects list when click 'Projects' button" do
      find('.js-show_project_menu_btn').click

      projects.each do |project|
        expect(find('.header')).to have_link project.name
      end
    end

    scenario "show user menu when click user name button" do
      find('.js-show_user_menu_btn').click

      expect(find('.header')).to have_link 'Logout'
    end
  end
end
