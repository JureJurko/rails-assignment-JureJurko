module Api
  class BookingsController < ApplicationController
    def index
      return error_message if check_user

      if find_user.role != 'admin'
        user_bookings(find_user)
      else
        render json: BookingSerializer.render(Booking.all, root: 'bookings'), status: :ok
      end
    end

    def show
      return error_message if check_user

      booking = Booking.find(params[:id])
      if find_user.role == 'admin' || find_user.id == booking.user_id
        render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
      else
        error_message
      end
    end

    def create
      return error_message if check_user

      booking = Booking.new(permitted_params)
      if valid_request(booking)
        save_booking(booking)
      else
        error_message
      end
    end

    def update
      return error_message if check_user

      booking = Booking.find(params[:id])
      if valid_request(booking)
        update_booking(booking)
      else
        error_message
      end
    end

    def destroy
      return error_message if check_user

      booking = Booking.find(params[:id])
      if valid_request(booking)
        booking.destroy
        head :no_content
      else
        error_message
      end
    end

    private

    def permitted_params
      params.require(:booking).permit(:no_of_seats,
                                      :seat_price,
                                      :user_id,
                                      :flight_id)
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token).nil?
    end

    def error_message
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end

    def user_bookings(user)
      render json: BookingSerializer.render(user.bookings,
                                            root: 'bookings'), status: :ok
    end

    def find_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def valid_request(booking)
      return true if find_user.role == 'admin' || find_user.id == booking.user_id
    end

    def save_booking(booking)
      if booking.save
        render json: BookingSerializer.render(booking, root: 'booking'), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update_booking(booking)
      if booking.update(permitted_params)
        render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end
  end
end
