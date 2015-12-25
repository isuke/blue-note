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
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:project_id) }

  it 'should end at is after start at' do
    iteration.start_at = '2000/01/02'
    iteration.end_at   = '2000/01/01'

    expect(iteration.valid?).to be_falsey
  end

  it 'should range not overlap other iteration range' do
    create(:iteration, project: iteration.project, start_at: '2000/01/10', end_at: '2000/01/20')
    iteration.start_at = '2000/01/19'
    iteration.end_at   = '2000/01/29'

    expect(iteration.valid?).to be_falsey
  end
end
