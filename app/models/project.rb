class Project < ActiveRecord::Base
  has_many :features

  validates :name, presence: true
end
