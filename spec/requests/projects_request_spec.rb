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
end
