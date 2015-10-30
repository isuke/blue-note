require 'rails_helper'

RSpec.describe 'user sessions request' do
  let!(:user) { create(:user, name: 'Alice', email: 'alice@example.com', password: 'foobar') }

  describe 'POST /api/login' do
    let(:path) { '/api/login' }

    context 'with correct parameter' do
      let(:params) do
        { user_session: { email: 'alice@example.com', password: 'foobar' } }
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 200
        expect(json['message']).to eq 'login successed'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        { user_session: { email: 'alice@example.com', password: 'hogehoge' } }
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'login faild'
      end
    end
  end

  describe 'DELETE /api/logout' do
    let(:path) { '/api/logout' }
    before { login(user) }

    it 'return success code and message' do
      delete path

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(json['message']).to eq 'logout successed'
    end
  end
end
