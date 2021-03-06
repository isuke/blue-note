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
  background { user.join!(project) }
  background do
    visit progress_path(project)
    wait_for_ajax
    sleep 0.5
  end

  subject { page }

  scenario 'show' do
    expect(page).to have_content 'Progress'
    expect(page).to have_content project.name

    expect(page).to have_css '#feature_list', visible: false

    expect(page).to have_css '#feature_new' , visible: false
  end

  feature 'feature list' do
    scenario 'show' do
      fill_in :feature_list_queue_str, with: 'status:todo,doing'
      aggregate_failures 'filter to status' do
        project.features.with_status(:todo, :doing).each do |feature|
          expect(page).to have_content feature.title
        end
        project.features.with_status(:done).each do |feature|
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

    scenario 'filtering list when filter status checked' do
      find('.feature_list__menu__filter').find('.feature_list__menu__item__inner--btn').click
      uncheck 'query_status_todo'
      check   'query_status_doing'
      check   'query_status_done'

      aggregate_failures 'filter to status' do
        project.features.with_status(:doing, :done).each do |feature|
          expect(page).to have_content feature.title
        end
        project.features.with_status(:todo).each do |feature|
          expect(page).not_to have_content feature.title
        end
      end
    end

    scenario 'show feature show view when click feature title' do
      feature = features.first

      find("#feature_#{feature.id}").find('.feature_list__items__list__item__title').click

      wait_for_ajax
      sleep 0.5

      expect(find('.feature_show__view')).to have_back_button
      expect(find('.feature_show__view')).to have_button 'Edit'
    end

    scenario 'delete selected feature when click delete button' do
      pending("this is faild")

      target_features = [features[0], features[1], features[2]]

      target_features.each do |feature|
        expect(find('.feature_list')).to have_content feature.title
      end

      target_features.each do |feature|
        check("feature_#{feature.id}_selected_check")
      end

      find('.feature_list__menu').click_on('delete')
      wait_for_ajax
      sleep 0.5

      target_features.each do |feature|
        expect(find('.feature_list')).not_to have_content feature.title
      end
    end

    scenario 'update feature status when click status update button'

    scenario 'update feature priority when drag and drop the feature'
  end

  feature 'feature show' do
    let(:feature) { features.first }
    background do
      find("#feature_#{feature.id}").find('.feature_list__items__list__item__title').click

      wait_for_ajax
      sleep 0.5
    end

    scenario 'show' do
      expect(find('.feature_show__item--title')).to      have_content feature.title
      expect(find('.feature_show__item--point')).to      have_content feature.point
      expect(find('.feature_show__item--status')).to     have_content feature.status
      expect(find('.feature_show__item--updated-at')).to have_content feature.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(find('.feature_show__view')).to have_back_button
      expect(find('.feature_show__view')).to have_button 'Edit'
    end

    scenario 'back to new feature when click back button' do
      find('.feature_show__view').find('.feature_show__btns__btn--back').click

      sleep 0.5

      expect(page).to have_css '.feature_new'
    end

    scenario 'show feature eidt when click edit button' do
      click_button 'Edit'

      sleep 0.5

      expect(find('.feature_show').find_field('title').value).to  eq feature.title
      expect(find('.feature_show').find_field('point').value).to  eq feature.point.to_s
      expect(find('.feature_show').find_field('status').value).to eq feature.status
    end

    context 'after click edit button' do
      background do
        click_button 'Edit'

        sleep 0.5
      end

      scenario 'update the feature when to update button' do
        find('.feature_show').fill_in :title , with: 'edited title'
        find('.feature_show').fill_in :point , with: '1'
        find('.feature_show').select 'Done', from:  :status
        click_button 'Update feature'

        sleep 0.5

        expect(find('.feature_show__item--title')).to      have_content 'edited title'
        expect(find('.feature_show__item--point')).to      have_content '1'
        expect(find('.feature_show__item--status')).to     have_content 'done'
        expect(find('.feature_show__item--title')).not_to  have_content feature.title
        expect(find('.feature_show__item--point')).not_to  have_content feature.point
        expect(find('.feature_show__item--status')).not_to have_content feature.status
        expect(find('.feature_show__view')).to have_back_button
        expect(find('.feature_show__view')).to have_button 'Edit'
      end
    end
  end

  feature 'new feature' do
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
