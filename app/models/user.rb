# == Schema Information
# Schema version: 20150812171015
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(50)       not null
#  email              :string(100)      not null
#  crypted_password   :string           not null
#  password_salt      :string           not null
#  persistence_token  :string           not null
#  login_count        :integer          default(0), not null
#  failed_login_count :integer          default(0), not null
#  current_login_at   :datetime
#  last_login_at      :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base
  acts_as_authentic

  validates :name, presence: true, length: { maximum: 50 }
end