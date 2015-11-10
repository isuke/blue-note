require 'rails_helper'

RSpec.describe 'projects request' do
  let!(:user)       { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  let!(:other_user) { create(:user, name: 'Bob'  , email: 'bob@example.com'  , password: 'foobar') }

  before { login(user) }

  describe 'GET /api/projects' do
    let(:path) { "/api/projects" }

    before do
      create(:member, user: user)
      create(:member, user: user)
      create(:member, user: other_user)
    end

    it 'return a list of projects' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 2
    end
  end

  describe 'POST /api/projects' do
    let(:path) { "/api/projects" }

    context 'with correct parameter' do
      let(:params) { { project: { name: 'my project' } } }

      it 'create a project' do
        expect do
          post path, params
        end.to change(Project, :count).by(1)
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).not_to eq nil
        expect(json['message']).to eq 'project was successfully created.'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) { { project: { name: '' } } }

      it 'do not create a project' do
        expect do
          post path, params
        end.not_to change(Project, :count)
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'project could not be created.'
      end
    end
  end

end
