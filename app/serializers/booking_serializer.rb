class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :hotel_id, :rooms_count, :check_in, :check_out, :status
end
