class Hotel < ApplicationRecord
  has_many :bookings
  has_many :users, through: :bookings

  validates :name, :location, presence: true
  validates :rooms_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
