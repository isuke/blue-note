# == Schema Information
# Schema version: 20151106014633
#
# Table name: iterations
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  number     :integer          not null
#  start_at   :date             not null
#  end_at     :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_iterations_on_project_id             (project_id)
#  index_iterations_on_project_id_and_number  (project_id,number) UNIQUE
#

class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :features

  validates :project , presence: true
  validates :number  , presence: true
  validates :start_at, presence: true
  validates :end_at  , presence: true
  validates :number  , allow_nil: false, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
