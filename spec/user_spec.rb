RSpec.describe User do
  it 'is invalid without name' do
    user = described_class.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without email' do
    user = described_class.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid email format' do
    user = described_class.new(first_name: 'User', email: 'prvi#gmail.com')
    user.valid?
    expect(user.errors[:email]).to include('is invalid')
  end
end
