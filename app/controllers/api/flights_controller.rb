module Api
  class FlightsController < ApplicationController
    def index
      render json: FlightSerializer.render(Flight.all, root: 'flights'), status: :ok
    end

    def show
      flight = Flight.find(params[:id])

      render json: FlightSerializer.render(flight, root: 'flight'), status: :ok
    end

    def create
      render json: error_message, status: :unauthorized if check_user.role != 'admin'

      flight = Flight.new(permitted_params)

      if flight.save
        render json: FlightSerializer.render(flight, root: 'flight'), status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def update
      render json: error_message, status: :unauthorized if check_user.role != 'admin'

      flight = Flight.find(params[:id])
      if flight.update(permitted_params)
        render json: FlightSerializer.render(flight, root: 'flight'), status: :ok
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      render json: error_message, status: :unauthorized if check_user.role != 'admin'

      flight = Flight.find(params[:id])
      flight.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:flight).permit(:name,
                                     :arrives_at,
                                     :departs_at,
                                     :base_price,
                                     :no_of_seats,
                                     :company_id)
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
