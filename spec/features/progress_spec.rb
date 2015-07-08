require 'rails_helper'

RSpec.feature 'Progress Page', js: true do
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
  background { visit progress_path(project) }

  subject { page }

  scenario 'show' do
    expect(page).to have_content 'Progress'
    expect(page).to have_content project.name
  end

  feature 'feature list' do

    scenario 'filter list' do
      expect(page).to have_content 'Feature List'

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
      aggregate_failures 'filter to status' do
        project.features.where('point >= 1').each do |feature|
          expect(page).to have_content feature.title
        end
        project.features.where('point < 1').each do |feature|
          expect(page).not_to have_content feature.title
        end
      end
    end
  end
end
