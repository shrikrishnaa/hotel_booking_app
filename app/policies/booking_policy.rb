class BookingPolicy < ApplicationPolicy

  def create?
    true
  end

  def show?
    user == record.user || user.is_admin?
  end

  def update?
    user == record.user || user.is_admin?
  end

  def destroy?
    user == record.user || user.is_admin?
  end

  def index?
    user.present?
  end

  def user_bookings?
    index?
  end

  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
