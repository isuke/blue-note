class Feature < ActiveRecord::Base
  extend Enumerize

  belongs_to :project

  enumerize :status, in: {todo: 10, doing: 20, done: 30}, default: :todo

  validates :project , presence: true
  validates :title   , presence: true
  validates :status  , presence: true
  validates :priority, allow_nil: true, numericality: { only_integer: true, greater_than:             0 }
  validates :point   , allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
