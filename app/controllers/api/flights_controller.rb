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
      flight = Flight.new(permitted_params)

      if flight.save
        render json: FlightSerializer.render(flight, root: 'flight'), status: :created
      else
        render json: flight.errors, status: :bad_request
      end
    end

    def update
      flight = Flight.find(params[:id])
      flight.update(permitted_params)

      render json: FlightSerializer.render(flight, root: 'flight'), status: :ok
    end

    def destroy
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
                                     :company)
    end
  end
end
