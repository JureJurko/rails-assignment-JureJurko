class FlightSerializer < Blueprinter::Base
  identifier :id

  field :name
  field :created_at
  field :updated_at
  field :no_of_seats
  field :base_price
  field :departs_at
  field :arrives_at

  association :company, blueprint: CompanySerializer
end
