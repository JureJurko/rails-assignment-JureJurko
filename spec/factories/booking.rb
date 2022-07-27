FactoryBot.define do
  factory :booking do
    no_of_seats { 50 }
    seat_price { 750 }
    user { FactoryBot.create(:user) }
    flight { FactoryBot.create(:flight) }
  end
end
