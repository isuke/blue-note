require 'rails_helper'

RSpec.describe 'features request' do
  let!(:user)    { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  let!(:project) { create(:project) }

  before { login(user) }
  before { user.join!(project) }

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

  describe 'GET /api/features/:id' do
    let!(:feature) { create(:feature, project: project) }
    let(:path) { "/api/features/#{feature.id}" }

    it 'return a feature' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json['id']).to         eq feature.id
      expect(json['project_id']).to eq feature.project_id
      expect(json['title']).to      eq feature.title
      expect(json['status']).to     eq feature.status
      expect(json['priority']).to   eq feature.priority
      expect(json['point']).to      eq feature.point
    end
  end

  describe 'POST /api/projects/:project_id/features' do
    let(:path) { "/api/projects/#{project.id}/features" }

    context 'with correct parameter' do
      let(:params) { { feature: { title: 'implement hoge', point: '1' } } }

      it 'create a feature' do
        expect do
          post path, params
        end.to change(Feature, :count).by(1)
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).not_to eq nil
        expect(json['message']).to eq 'feature was successfully created.'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) { { feature: { title: '', point: '1' } } }

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

  describe 'PATCH /api/features/:id' do
    let(:feature) { create(:feature, project: project, title: 'implement hoge', point: '1', status: 'todo') }
    let(:path) { "/api/features/#{feature.id}" }

    context 'with correct parameter' do
      let(:params) { { feature: { title: 'upgrade hoge', point: '2', status: 'doing' } } }

      it 'return success code and message' do
        patch path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).to eq feature.id
        expect(json['message']).to eq 'feature was successfully updated.'

        feature.reload

        expect(feature.title).to    eq 'upgrade hoge'
        expect(feature.point).to    eq 2
        expect(feature.status).to   eq 'doing'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) { { feature: { title: '', point: '2', status: 'doing' } } }

      it 'return 422 Unprocessable Entity code and message' do
        patch path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'feature could not be updated.'

        feature.reload

        expect(feature.title).not_to    eq 'upgrade hoge'
        expect(feature.point).not_to    eq 2
        expect(feature.status).not_to   eq 'doing'
      end
    end
  end

  describe 'PATCH /api/features/:id/update_priority' do
    before { 5.times { |i| create(:feature, project: project, priority: i + 1) } }

    let(:feature) { create(:feature, project: project, priority: 5) }
    let(:path) { "/api/features/#{feature.id}/update_priority" }

    context 'with number param' do
      let(:params) { { insert_at: 2 } }

      it 'return success code and message' do
        patch path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['message']).to eq 'feature was successfully updated.'

        feature.reload

        expect(feature.priority).to eq 2
      end
    end
  end

  describe 'PATCH /api/projects/:project_id/features/update_all' do
    let(:features) { create_list(:feature, 3, project: project, status: :todo) }
    let(:path) { "/api/projects/#{project.id}/features/update_all" }
    let(:params) { { features: features.map { |f| { id: f.id, status: :done } } } }

    it 'update the features' do
      patch path, params

      features.each do |feature|
        feature.reload
        expect(feature.status).to eq 'done'
      end
    end

    it 'return success code and message' do
      patch path, params

      expect(response).to be_success
      expect(response.status).to eq 201

      expect(json['message']).to eq 'feature was successfully updated.'
    end
  end

  describe 'DELETE /api/projects/:project_id/features/destroy_all' do
    let(:features) { create_list(:feature, 3, project: project) }
    let(:path) { "/api/projects/#{project.id}/features/destroy_all" }
    let(:params) { { ids: features.map(&:id) } }

    it 'destroy the features' do
      features
      expect do
        delete path, params
      end.to change(Feature, :count).by(-3)
    end

    it 'return success code and message' do
      delete path, params

      expect(response).to be_success
      expect(response.status).to eq 200

      expect(json['message']).to eq 'feature was successfully destroyed.'
    end
  end
end
