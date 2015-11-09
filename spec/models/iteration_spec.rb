require 'rails_helper'

RSpec.describe Iteration do
  let(:iteration) { build(:iteration) }
  subject { iteration }

  it { is_expected.to respond_to(:project) }
  it { is_expected.to respond_to(:features) }
  it { is_expected.to respond_to(:number) }
  it { is_expected.to respond_to(:start_at) }
  it { is_expected.to respond_to(:end_at) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:features) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:end_at) }
  it { is_expected.to validate_numericality_of(:number).only_integer }
  it { is_expected.to validate_numericality_of(:number).is_greater_than_or_equal_to(1) }
end
