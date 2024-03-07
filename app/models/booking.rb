class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  validates :check_in, :check_out, presence: true
  validate :check_out_after_check_in, :validate_room_count, :set_status

  private

  def check_out_after_check_in
    return if check_out.blank? || check_in.blank?
    if check_out <= check_in
      errors.add(:check_out_date, "must be after the check-in date")
    end
  end

  def set_status
    self.status ||= 'confirmed'
  end

  def validate_room_count
    return unless hotel.present? && rooms_count > hotel.rooms_count
    errors.add(:rooms_count, "cannot exceed the available rooms in the hotel")
  end
end
