require 'rails_helper'

RSpec.describe 'members request' do
  let!(:user)    { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }
  let!(:project) { create(:project) }

  before { login(user) }
  before { user.join!(project) }

  describe 'GET /api/projects/:project_id/members' do
    let!(:member1) { create(:member, project: project) }
    let!(:member2) { create(:member, project: project) }
    let(:path) { "/api/projects/#{project.id}/members" }

    it 'return a list of members' do
      get path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json.count).to eq 3
    end
  end

  describe 'POST /api/projects/:project_id/members' do
    let(:other_user) { create(:user, email: 'bob@example.com') }
    let(:path) { "/api/projects/#{project.id}/members" }
    let(:params) { { member: { email: other_user.email, role: 'general' } } }

    context 'user role is admin' do
      before do
        member = user.member_of(project)
        member.role = :admin
        member.save!
      end

      context 'with correct parameter' do
        it 'create a member' do
          expect do
            post path, params
          end.to change(Member, :count).by(1)
        end

        it 'return success code and message' do
          post path, params

          expect(response).to be_success
          expect(response.status).to eq 201

          expect(json['id']).not_to eq nil
          expect(json['message']).to eq 'member was successfully created.'
        end
      end

      context 'with uncorrect parameter' do
        before { other_user.join!(project) }

        it 'do not create a feature' do
          expect do
            post path, params
          end.not_to change(Member, :count)
        end

        it 'return 422 Unprocessable Entity code and message' do
          post path, params

          expect(response).not_to be_success
          expect(response.status).to eq 422

          expect(json['message']).to eq 'member could not be created.'
        end
      end
    end
  end

end
