require 'rails_helper'

RSpec.feature 'Project Settings Page', js: true do
  given!(:project) { create(:project) }
  given!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  background { login user, with_capybara: true }
  background { visit project_settings_path(project) }

  subject { page }

  scenario 'show' do
    expect(find('.header')).to have_content 'Dashboard'
  end

  feature 'members' do
    given!(:other_user) { create(:user, email: 'bob@example.com') }
    given(:users) { create_list(:user, 3) }
    background { users.each { |user| user.join!(project) } }
    background { visit project_settings_path(project) }

    scenario 'show' do
      project.members.includes(:user).each do |member|
        expect(page).to have_content member.role
        expect(page).to have_content member.user.name
        expect(page).to have_content member.user.email
      end
    end

    scenario 'create new member when click add member button' do
      fill_in 'user_email', with: 'bob@example.com'
      select 'Admin', from: 'role'
      click_button 'Add member'

      wait_for_ajax
      sleep 0.5

      member = other_user.member_of(project)
      expect(find("#member_#{member.id}")).to have_content 'admin'
      expect(find("#member_#{member.id}")).to have_content other_user.name
      expect(find("#member_#{member.id}")).to have_content other_user.email
    end
  end
end
