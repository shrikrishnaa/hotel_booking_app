class HotelSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :rooms_count
end