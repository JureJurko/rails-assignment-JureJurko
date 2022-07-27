FactoryBot.define do
  factory :flight do
    name { 'Zagreb - Venecija' }
    arrives_at { DateTime.new(2022, 10, 12, 5, 45, 0) }
    departs_at { DateTime.new(2022, 10, 12, 0, 0, 0) }
    no_of_seats { 50 }
    base_price { 750 }
    company { FactoryBot.create(:company) }
  end
end
