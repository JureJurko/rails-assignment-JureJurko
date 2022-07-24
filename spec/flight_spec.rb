RSpec.describe Flight do
  let(:company) do
    Company.new(name: 'Croatian Airlines')
  end

  let(:flight) do
    described_class.new(name: nil,
                        departs_at: nil,
                        arrives_at: nil,
                        no_of_seats: nil,
                        base_price: nil)
  end

  let(:new_flight) do
    described_class.new(name: 'Zagreb to Split',
                        departs_at: DateTime.new(2001, 2, 3, 4, 5, 6),
                        arrives_at: DateTime.new(2001, 2, 3, 5, 0, 0),
                        no_of_seats: 50,
                        base_price: 750,
                        company: company)
  end

  it 'is invalid if any of attributes is blank' do
    flight.valid?
    expect(flight.errors[:name]).to include("can't be blank")
    expect(flight.errors[:departs_at]).to include("can't be blank")
    expect(flight.errors[:arrives_at]).to include("can't be blank")
    expect(flight.errors[:base_price]).to include("can't be blank")
    expect(flight.errors[:no_of_seats]).to include("can't be blank")
  end

  it 'is invalid if name is already taken in scope of comapny' do
    new_flight.save
    new_flight1 = described_class.new(name: 'zagreb to split',
                                      departs_at: DateTime.new(2001, 2, 3, 4, 5, 6),
                                      arrives_at: DateTime.new(2001, 2, 3, 5, 0, 0),
                                      no_of_seats: 50,
                                      base_price: 750,
                                      company: company)
    new_flight1.valid?
    expect(new_flight1.errors[:name]).to include('has already been taken')
  end

  it 'is invalid if departs_at is after arrives_at' do
    flight.departs_at = DateTime.new(2001, 2, 2, 2, 2, 2)
    flight.arrives_at = DateTime.new(2000, 2, 2, 2, 2, 2)
    flight.valid?
    expect(flight.errors[:departs_at]).to include('must be before arrives_at')
  end

  it 'is invalid if no_of_seats or base_price are 0 or less' do
    flight.no_of_seats = 0
    flight.base_price = 0
    flight.valid?
    expect(flight.errors[:base_price]).to include('must be greater than 0')
    expect(flight.errors[:no_of_seats]).to include('must be greater than 0')
  end
end
