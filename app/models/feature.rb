# == Schema Information
# Schema version: 20151207045952
#
# Table name: features
#
#  id           :integer          not null, primary key
#  project_id   :integer          not null
#  title        :string           not null
#  status       :integer          not null
#  priority     :integer          not null
#  point        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  iteration_id :integer
#
# Indexes
#
#  index_features_on_project_id               (project_id)
#  index_features_on_project_id_and_point     (project_id,point)
#  index_features_on_project_id_and_priority  (project_id,priority)
#  index_features_on_project_id_and_status    (project_id,status)
#

class Feature < ActiveRecord::Base
  extend Enumerize

  belongs_to :project
  belongs_to :iteration
  acts_as_list scope: :project, column: :priority, top_of_list: 1, add_new_at: :bottom

  enumerize :status, in: { todo: 10, doing: 20, done: 30 }, default: :todo, scope: true

  validates :project , presence: true
  validates :title   , presence: true
  validates :status  , presence: true
  validates :priority, allow_nil: true, numericality: { only_integer: true, greater_than:             0 }
  validates :point   , allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
