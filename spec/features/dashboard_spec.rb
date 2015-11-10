require 'rails_helper'

RSpec.feature 'Dashboard Page', js: true do
  given!(:projects) { create_list(:project, 3) }
  given!(:user) { create(:user, :with_projects, name: 'Alice', email: 'alice@example.com', password: 'foobar', projects: projects) }
  background { login user, with_capybara: true }
  background { visit dashboard_path }

  subject { page }

  feature 'project list' do
    scenario 'show' do
      expect(find('.header')).to have_content 'Dashboard'

      projects.each do |project|
        expect(page).to have_content project.name
      end
    end

    scenario 'link to a project progress page when click the project name' do
      project = projects.first

      find("#project_#{project.id}").click

      expect(find('.header')).to have_content project.name
    end

    scenario 'create new project when click create project button' do
      fill_in 'project_name', with: 'New Project'
      click_button 'Create Project'

      wait_for_ajax
      sleep 0.5

      expect(find('.project_list')).to have_content 'New Project'
    end
  end
end
