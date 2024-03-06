class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]

  def index
    @bookings = current_user.bookings
    render json: @bookings
  end

  def show
    authorize @booking
    render json: @booking
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    authorize @booking
    if @booking.save
      render json: @booking, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @booking
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @booking
    @booking.destroy
    head :no_content
  end

  def user_bookings
    @bookings = current_user.bookings
    authorize @bookings, :user_bookings?
    render json: @bookings
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:hotel_id, :check_in, :check_out, :rooms_count)
  end
end