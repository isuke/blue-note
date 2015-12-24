require 'rails_helper'

RSpec.describe 'iterations request' do
  let!(:user)    { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  let!(:project) { create(:project) }

  before { login(user) }
  before { user.join!(project) }

  describe 'GET /api/projects/:project_id/iterations' do
    let!(:iteration1) { create(:iteration, project: project) }
    let!(:iteration2) { create(:iteration, project: project) }
    let!(:others)   { create(:project, :with_iterations) }
    let(:path) { "/api/projects/#{project.id}/iterations" }

    it 'return a list of iterations' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 2

      expect(json[0]['id']).to     eq iteration1.id
      expect(json[0]['number']).to eq iteration1.number
    end
  end
end
