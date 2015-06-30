require 'rails_helper'

RSpec.describe PagesController do

  subject { response }

  describe 'GET #progress' do
    let(:project) { create(:project, :with_features) }
    before { get :progress, project_id: project.id }

    it { is_expected.to render_template :progress }
  end

end
