class HotelPolicy < ApplicationPolicy
  attr_reader :user, :hotel

  def initialize(user, hotel)
    @user = user
    @hotel = hotel
  end

  def index?
    true # Anyone can view the list of hotels
  end

  def show?
    true # Anyone can view hotel details
  end

  def create?
    user.is_admin? # Only admin users can create hotels
  end

  def update?
    user.is_admin? # Only admin users can update hotels
  end

  def destroy?
    user.is_admin? # Only admin users can delete hotels
  end

  class Scope < Scope
    def resolve
      scope.where(public: true) # Non-admins can see only public hotels
    end
  end
end