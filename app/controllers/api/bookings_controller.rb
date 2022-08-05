module Api
  class BookingsController < ApplicationController
    def index
      if check_user && check_user.role == 'admin'
        render json: BookingSerializer.render(Bookings.all, root: 'bookings'), status: :ok
      elsif check_user.role.nil?
        render json: BookingSerializer.render(all_bookings, root: 'bookings'), status: :ok
      else
        error_message
      end
    end

    def show
      booking = Booking.find(params[:id])
      if check_user.nil? || check_user.id != booking.user_id || check_user.role != 'admin'
        error_message
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
        error_message
      end
    end

    def update
      booking = Booking.find(params[:id])
      if check_user.id != booking.user_id && check_user.role != 'admin'
        error_message
      elsif booking.update(permitted_params)
        render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      error_message if check_user.id != booking.user_id || check_user.role != 'admin'

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
      Bookings.all.filter { |booking| booking.user_id == user.id }
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def error_message
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end
  end
end
