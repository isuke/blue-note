require 'rails_helper'

RSpec.describe 'features request' do
  let!(:project)  { create(:project) }

  describe 'GET /api/projects/:project_id/features' do
    let!(:feature1) { create(:feature, project: project) }
    let!(:feature2) { create(:feature, project: project) }
    let!(:others)   { create(:project, :with_features) }
    let(:path) { "/api/projects/#{project.id}/features" }

    it 'return a list of features' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 2
    end
  end

  describe 'POST /api/projects/:project_id/features' do
    let(:path) { "/api/projects/#{project.id}/features" }

    context 'with correct parameter' do
      let(:params) { { feature: { title: 'implement hoge', priority: '1', point: '1' } } }

      it 'create a feature' do
        expect do
          post path, params
        end.to change(Feature, :count).by(1)
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['message']).to eq 'feature was successfully created.'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) { { feature: { title: 'implement hoge', priority: '0', point: '1' } } }

      it 'do not create a feature' do
        expect do
          post path, params
        end.not_to change(Feature, :count)
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'feature could not be created.'
      end
    end

  end

end
