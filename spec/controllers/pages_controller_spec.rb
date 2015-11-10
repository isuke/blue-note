require 'rails_helper'

RSpec.describe PagesController do

  let!(:user)   { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }

  subject { response }

  describe 'GET #home' do
    before { get :home }

    it { is_expected.to render_template :home }
  end

  describe 'GET #dashboard' do
    before { login(user) }
    before { get :dashboard }

    it { is_expected.to render_template :dashboard }
  end

  describe 'GET #progress' do
    let(:project) { create(:project, :with_features) }
    before { login(user) }

    context 'login user join the project' do
      before { user.join!(project) }
      before { get :progress, project_id: project.id }

      it { is_expected.to render_template :progress }
    end

    context 'login user not join the project' do
      before { get :progress, project_id: project.id }

      it { is_expected.to redirect_to root_path }
    end
  end

  describe 'GET #project_settings' do
    let(:project) { create(:project, :with_features) }
    before { login(user) }

    context 'login user join the project' do
      before { user.join!(project) }
      before { get :project_settings, project_id: project.id }

      it { is_expected.to render_template :project_settings }
    end

    context 'login user not join the project' do
      before { get :project_settings, project_id: project.id }

      it { is_expected.to redirect_to root_path }
    end
  end
end
