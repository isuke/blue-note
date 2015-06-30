require 'rails_helper'

RSpec.describe 'features request' do
  describe 'GET /projects/:project_id/features' do
    let!(:project)  { create(:project) }
    let!(:feature1) { create(:feature, project: project) }
    let!(:feature2) { create(:feature, project: project) }
    let!(:others)   { create(:project, :with_features) }

    before { get "/projects/#{project.id}/features" }

    it 'sends a list of features' do
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 2
    end

  end

end
