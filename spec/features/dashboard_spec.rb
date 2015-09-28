require 'rails_helper'

RSpec.feature 'Dashboard Page', js: true do
  given!(:projects) { create_list(:project, 3) }
  given!(:user) { create(:user, :with_projects, name: 'Alice', email: 'alice@example.com', password: 'foobar', projects: projects) }
  background { login user, with_capybara: true }
  background { visit dashboard_path }

  subject { page }

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
end
