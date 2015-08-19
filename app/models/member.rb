# == Schema Information
# Schema version: 20150819163656
#
# Table name: members
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  project_id :integer          not null
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_members_on_project_id              (project_id)
#  index_members_on_user_id                 (user_id)
#  index_members_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#

class Member < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :project

  validates :user   , presence: true
  validates :project, presence: true
  validates :role   , presence: true
  validates :user_id, uniqueness: { scope: :project_id }

  enumerize :role, in: { admin: 10, general: 30 }, predicates: true
end
