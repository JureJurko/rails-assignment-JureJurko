module Api
  class BookingsController < ApplicationController
    def index
      if check_user
        render json: { bookings: all_bookings }, status: :ok
      else
        render json: error_message, status: :unauthorized
      end
    end

    def show
      booking = Booking.find(params[:id])
      if check_user.nil? || check_user.id != booking.user_id
        render json: error_message, status: :unauthorized
      else
        render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
      end
    end

    def create
      booking = Booking.new(permitted_params)
      if check_user
        if booking.save
          render json: BookingSerializer.render(booking, root: 'booking'), status: :created
        else
          render json: { errors: booking.errors }, status: :bad_request
        end
      else
        render json: error_message, status: :unauthorized
      end
    end

    def update
      booking = Booking.find(params[:id])
      if check_user.id != booking.user_id
        render json: error_message, status: :unauthorized
      elsif booking.update(permitted_params)
        render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      render json: error_message, status: :unauthorized if check_user.id != booking.user_id

      booking = Booking.find(params[:id])
      booking.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:booking).permit(:no_of_seats,
                                      :seat_price,
                                      :user_id,
                                      :flight_id)
    end

    def all_bookings
      Bookings.map { |booking| booking.user_id == user.id }.each do |booking|
        BookingSerializer.render(booking)
      end
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def error_message
      { errors: { token: ['is invalid'] } }
    end
  end
end
