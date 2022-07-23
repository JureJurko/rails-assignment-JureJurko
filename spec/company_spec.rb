RSpec.describe Company do
  let(:company)  { described_class.create(name: nil) }

  it 'is invalid when name is blank' do
    company.valid?
    expect(company.errors[:name]).to include("can't be blank")
  end

  it 'is invalid when name is already taken' do
    company.name = 'Croatia Airlines'
    company.save
    new_company = described_class.new(name: 'croatia airlines')
    new_company.valid?
    expect(new_company.errors[:name]).to include('has already been taken')
  end
end
