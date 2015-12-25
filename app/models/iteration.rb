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
  has_many :features, dependent: :destroy

  validates :project , presence: true
  validates :number  , presence: true
  validates :start_at, presence: true
  validates :end_at  , presence: true
  validates :number  , allow_nil: false, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :number  , uniqueness: { scope: :project_id }
  validate :end_at_is_after_start_at
  validate :range_not_overlap

private

  def end_at_is_after_start_at
    return if end_at.blank? || start_at.blank?

    if end_at <= start_at
      errors.add(:end_at, 'cannot be before the start at')
    end
  end

  def range_not_overlap
    return if end_at.blank? || start_at.blank?

    project.iterations.where.not(id: id).each do |other|
      unless (self.end_at <= other.start_at) || (other.end_at <= self.start_at)
        errors.add(:start_at, 'and end at not overlap other iteration range')
      end
    end
  end
end
