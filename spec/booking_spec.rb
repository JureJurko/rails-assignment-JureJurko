RSpec.describe Booking do
  let(:company) do
    Company.new(name: 'Croatian Airlines')
  end

  let(:user) do
    User.new(first_name: 'Pero', email: 'pero@gmail.com')
  end

  let(:booking) do
    described_class.new(no_of_seats: nil, seat_price: nil, flight: flight, user: user)
  end

  let(:flight) do
    Flight.new(name: 'Zagreb to Split',
               departs_at: DateTime.new(2001, 2, 3, 4, 5, 6),
               arrives_at: DateTime.new(2001, 2, 3, 5, 0, 0),
               no_of_seats: 50,
               base_price: 750,
               company: company)
  end

  it 'is invalid when no_of_seats or base_price are not present' do
    booking.valid?
    expect(booking.errors[:no_of_seats]).to include("can't be blank")
    expect(booking.errors[:seat_price]).to include("can't be blank")
  end

  it 'is invalid when no_of_seats or seat_price are 0 or less' do
    booking.seat_price = 0
    booking.no_of_seats = 0
    booking.valid?
    expect(booking.errors[:no_of_seats]).to include('must be greater than 0')
    expect(booking.errors[:seat_price]).to include('must be greater than 0')
  end

  it 'is invalid when departs_at is in past' do
    booking.valid?
    expect(booking.errors[:flight]).to include('departs_at after current date')
  end
end
