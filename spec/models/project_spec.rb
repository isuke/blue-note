require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }
  subject { project }

  it { is_expected.to respond_to(:features) }
  it { is_expected.to respond_to(:name) }

  it { is_expected.to respond_to(:member_of) }

  it { is_expected.to have_many(:members) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:features) }

  it { is_expected.to validate_presence_of(:name) }
end
