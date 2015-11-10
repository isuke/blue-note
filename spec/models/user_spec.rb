require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }
  subject { user }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:login_count) }
  it { is_expected.to respond_to(:failed_login_count) }
  it { is_expected.to respond_to(:current_login_at) }
  it { is_expected.to respond_to(:last_login_at) }

  it { is_expected.to respond_to(:member_build) }
  it { is_expected.to respond_to(:join) }
  it { is_expected.to respond_to(:join!) }
  it { is_expected.to respond_to(:member_of) }
  it { is_expected.to respond_to(:role_in) }

  it { is_expected.to have_many(:members) }
  it { is_expected.to have_many(:projects) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }

  it { is_expected.to validate_length_of(:email).is_at_most(100) }
  it { is_expected.to allow_value('foobar@example.com', 'foobar@example.co.en').for(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to validate_numericality_of(:login_count).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:login_count).only_integer }
  it { is_expected.to validate_numericality_of(:login_count).allow_nil }

  it { is_expected.to validate_numericality_of(:failed_login_count).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:failed_login_count).only_integer }
  it { is_expected.to validate_numericality_of(:failed_login_count).allow_nil }

  it { is_expected.to validate_length_of(:password).is_at_least(4) }
  it { is_expected.to validate_confirmation_of(:password) }

  describe '#join' do
    let(:project) { create(:project) }
    before { user.join project, role: :admin }
    it 'the user join a project' do
      expect(user.member_of(project)).to be_truthy
    end
  end

  describe '#join!' do
    let(:project) { create(:project) }
    before { user.join! project, role: :admin }
    it 'is the user join a project' do
      expect(user.member_of(project)).to be_truthy
    end
  end
end
