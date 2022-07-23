# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true, length: { minimum: 2 }
end
