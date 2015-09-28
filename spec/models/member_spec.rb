require 'rails_helper'

RSpec.describe Member do
  let(:member) { build(:member) }
  subject { member }

  it { is_expected.to respond_to(:role) }
  it { is_expected.to respond_to(:admin?) }
  it { is_expected.to respond_to(:general?) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:project) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:project) }
  it { is_expected.to validate_presence_of(:role) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:project_id) }
end
