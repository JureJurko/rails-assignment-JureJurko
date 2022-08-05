module Api
  class BookingsController < ApplicationController
    def index
      return error_message if check_user

      user_bookings(find_user)
    end

    def show
      return error_message if check_user

      booking = Booking.find(params[:id])
      return error_message if booking.user_id != find_user.id

      render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
    end

    def create
      return error_message if check_user

      booking = Booking.new(permitted_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: 'booking'), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      return error_message if check_user

      booking = Booking.find(params[:id])
      return error_message if booking.user_id != find_user.id

      if booking.update(permitted_params)
        render json: BookingSerializer.render(booking, root: 'booking'), status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      return error_message if check_user

      booking = Booking.find(params[:id])
      return error_message if booking.id != find_user.id

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
  end
end
