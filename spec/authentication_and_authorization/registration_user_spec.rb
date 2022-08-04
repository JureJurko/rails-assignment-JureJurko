RSpec.describe User do
  let(:user) { FactoryBot.create(:user) }

  it 'updates when given correct password' do
    user.password = 'abcd'
    expect(user.save).to eq(true)
  end

  it 'returns error when given wrong password' do
    user.password = nil
    user.save
    expect(user.errors['password']).to include("can't be blank")
    user.password = ''
    user.save
    expect(user.errors['password']).to include("can't be blank")
  end
end
