require 'rails_helper'

RSpec.feature 'Project Settings Page', js: true do
  given!(:project) { create(:project) }
  given!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  background { login user, with_capybara: true }
  background { user.join!(project) }
  background do
    visit project_settings_path(project)
    wait_for_ajax
    sleep 0.5
  end

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

    context 'when user role is admin' do
      background do
        member = user.member_of(project)
        member.role = :admin
        member.save!
      end
      background do
        # TODO: raise following error often.
        #   Capybara::Poltergeist::DeadClient:
        #   PhantomJS client died while processing {"name":"visit","args":["http://127.0.0.1:61022/projects/574/project_settings"]}
        page.driver.browser.clear_network_traffic

        visit project_settings_path(project)
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

    context 'when user role is not admin' do
      background { visit project_settings_path(project) }

      scenario 'not exists add member form' do
        expect(page).to_not have_button 'Add member'
      end
    end
  end
end
