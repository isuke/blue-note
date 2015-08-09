require 'rails_helper'

RSpec.describe PagesController do

  subject { response }

  describe 'GET #home' do
    before { get :home }

    it { is_expected.to render_template :home }
  end

  describe 'GET #progress' do
    let(:project) { create(:project, :with_features) }
    before { get :progress, project_id: project.id }

    it { is_expected.to render_template :progress }
  end

end
