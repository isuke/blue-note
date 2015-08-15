require 'rails_helper'

RSpec.describe 'users request' do
  describe 'POST /api/users and /api/sign_up' do
    let(:path) { '/api/users' }

    context 'with correct parameter' do
      let(:params) do
        {
          user:
            {
              name:     'Alice',
              email:    'alice@example.com',
              password: 'password',
              password_confirmation: 'password',
            },
        }
      end

      it 'create a user' do
        expect do
          post path, params
        end.to change(User, :count).by(1)
      end

      it 'return success code and message' do
        post path, params

        expect(response).to be_success
        expect(response.status).to eq 201

        expect(json['id']).not_to eq nil
        expect(json['message']).to eq 'user was successfully created.'
      end
    end

    context 'with uncorrect parameter' do
      let(:params) do
        {
          user:
            {
              name:     'Alice',
              email:    'alice@example.com',
              password: 'password',
              password_confirmation: 'foobar',
            },
        }
      end

      it 'do not create a feature' do
        expect do
          post path, params
        end.not_to change(Feature, :count)
      end

      it 'return 422 Unprocessable Entity code and message' do
        post path, params

        expect(response).not_to be_success
        expect(response.status).to eq 422

        expect(json['message']).to eq 'user could not be created.'
      end
    end
  end
end
