class BookingSerializer < Blueprinter::Base
  identifier :id

  field :no_of_seats
  field :seat_price

  association :flight, blueprint: FlightSerializer
  association :user, blueprint: UserSerializer
end
