module Api
  class BookingsController < ApplicationController
    def index
      render json: BookingSerializer.render(Booking.all, root: 'bookings'), status: :ok
    end

    def show
      booking = Booking.find(params[:id])

      render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
    end

    def create
      booking = Booking.new(permitted_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: 'booking'), status: :created
      else
        render json: booking.errors, status: :bad_request
      end
    end

    def update
      booking = Booking.find(params[:id])
      booking.update(permitted_params)

      render json: BookingSerializer.render(booking, root: 'bookings'), status: :ok
    end

    def destroy
      booking = Booking.find(params[:id])
      booking.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:booking).permit(:no_of_seats, :seat_price)
    end
  end
end
