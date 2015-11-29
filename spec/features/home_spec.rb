require 'rails_helper'

RSpec.feature 'Home Page', js: true do
  given!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  background { visit home_path }

  subject { page }

  scenario 'show' do
    expect(page).to have_selector 'h1', text: 'Blue Note'
  end

  scenario 'sign up' do
    expect(find('.header')).not_to have_content 'Bob'

    click_on 'Sign Up', match: :first

    find('.sign_up_modal').fill_in 'name'                  , with: 'Bob'
    find('.sign_up_modal').fill_in 'email'                 , with: 'bob@example.com'
    find('.sign_up_modal').fill_in 'password'              , with: 'password'
    find('.sign_up_modal').fill_in 'password_confirmation' , with: 'password'
    find('.sign_up_modal').find_button('Sign Up').trigger('click')

    wait_for_ajax
    sleep 0.5

    expect(page).not_to have_css '.toast-error'
    expect(find('.header')).to have_content 'Bob'
  end

  scenario 'login' do
    expect(find('.header')).not_to have_content 'Alice'

    click_on 'Login', match: :first

    find('.login_modal').fill_in 'email'                 , with: 'alice@example.com'
    find('.login_modal').fill_in 'password'              , with: 'foobar'
    find('.login_modal').click_on 'Login'

    wait_for_ajax
    sleep 0.5

    expect(page).not_to have_css '.toast-error'
    expect(find('.header')).to have_content 'Dashboard'
    expect(find('.header')).to have_content 'Alice'
  end

  scenario 'logout' do
    login user, with_capybara: true
    visit home_path

    expect(find('.header')).to have_content 'Alice'
    find('span', text: 'Alice').click
    click_on 'Logout'

    wait_for_ajax
    sleep 0.5

    expect(page).not_to have_css '.toast-error'
    expect(find('.header')).not_to have_content 'Alice'
    expect(find('.header')).to have_content 'Login'
  end

end
