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
    before { get :progress, project_id: project.id }

    it { is_expected.to render_template :progress }
  end

end
