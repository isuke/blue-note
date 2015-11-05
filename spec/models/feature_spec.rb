require 'rails_helper'

RSpec.describe Feature do
  let(:feature) { build(:feature) }
  subject { feature }

  it { is_expected.to respond_to(:project) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:priority) }
  it { is_expected.to respond_to(:point) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_numericality_of(:point).only_integer }
  it { is_expected.to validate_numericality_of(:point).is_greater_than_or_equal_to(0) }
end
