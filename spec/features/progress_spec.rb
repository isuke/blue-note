require 'rails_helper'

RSpec.feature 'Progress Page', js: true do
  given!(:user)    { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  given!(:project) { create(:project) }
  given!(:features) do
    [:todo, :doing, :done].product((0..3).to_a).map do |(status, point)|
      create(
        :feature,
        project: project,
        title:   "project_#{status}_#{point}",
        status:  status,
        point:   point,
      )
    end
  end
  background { login user, with_capybara: true }
  background { visit progress_path(project) }

  subject { page }

  scenario 'show' do
    expect(page).to have_content 'Progress'
    expect(page).to have_content project.name

    expect(page).to have_css '#feature_list', visible: false

    expect(page).to have_css '#feature_new' , visible: false
  end

  feature 'featuer list' do
    scenario 'show' do
      fill_in :feature_list_queue_str, with: 'status:todo,doing'
      aggregate_failures 'filter to status' do
        project.features.where(status: [:todo, :doing]).each do |feature|
          expect(page).to have_content feature.title
        end
        project.features.where(status: [:done]).each do |feature|
          expect(page).not_to have_content feature.title
        end
      end

      fill_in :feature_list_queue_str, with: 'point:>=1'
      aggregate_failures do
        project.features.where('point >= 1').each do |feature|
          expect(page).to have_content feature.title
        end
        project.features.where('point < 1').each do |feature|
          expect(page).not_to have_content feature.title
        end
      end
    end
  end

  feature 'new featuer' do
    scenario 'create new feature when click create button with correct values' do
      aggregate_failures do
        fill_in :new_feature_title, with: 'my new feature'
        fill_in :new_feature_point, with: 3
        expect do
          click_button 'Create new feature'
          wait_for_ajax
        end.to change(Feature, :count).by(1)
        expect(find('.toast-success')).to have_content('feature was successfully created.')
        expect(page).to have_field(:new_feature_title, with: '')
        expect(page).to have_field(:new_feature_point, with: '')
      end
    end

    scenario 'create new feature when click create button with uncorrect values' do
      aggregate_failures do
        fill_in :new_feature_title, with: ' '
        fill_in :new_feature_point, with: -1
        expect do
          click_button 'Create new feature'
          wait_for_ajax
        end.not_to change(Feature, :count)
        expect(find('.toast-error')).to have_content("feature could not be created.")
        expect(find('.toast-error')).to have_content("title can't be blank")
        expect(find('.toast-error')).to have_content("point must be greater than or equal to 0")
        expect(page).to have_field(:new_feature_title, with: ' ')
        expect(page).to have_field(:new_feature_point, with: -1)
      end
    end
  end
end
