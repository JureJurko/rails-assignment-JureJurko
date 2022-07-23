# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  arrives_at  :datetime         not null
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  name        :string           not null
#  no_of_seats :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_flights_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :company, case_sensitive: false }
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validate :arrives_at_after_departs_at

  def arrives_at_after_departs_at
    return if arrives_at.blank? || departs_at.blank?

    errors.add(:arrives_at, 'must be after departs_at') if arrives_at < departs_at
  end
end
