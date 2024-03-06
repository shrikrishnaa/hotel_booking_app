class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show, :filter_by_location]

  def index
    @hotels = Hotel.all
    render json: @hotels
  end

  def show
    render json: @hotel
  end

  def create
    @hotel = current_user.hotels.build(hotel_params)
    authorize @hotel
    if @hotel.save
      render json: @hotel, status: :created
    else
      render json: @hotel.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @hotel
    if @hotel.update(hotel_params)
      render json: @hotel
    else
      render json: @hotel.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @hotel
    @hotel.destroy
    head :no_content
  end

  def filter_by_location
    @hotels = Hotel.where(location: params[:location])
    render json: @hotels
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def hotel_params
    params.require(:hotel).permit(:name, :location, :rooms_count)
  end
end