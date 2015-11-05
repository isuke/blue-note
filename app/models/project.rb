# == Schema Information
# Schema version: 20150617174858
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ActiveRecord::Base
  has_many :members
  has_many :users, through: :members
  has_many :features, -> { order(priority: :asc) }

  validates :name, presence: true

  def member_of(user)
    user.member_of(self)
  end
end
