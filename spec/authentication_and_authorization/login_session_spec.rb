RSpec.describe Session do
  let(:user) { FactoryBot.create(:user) }

  it 'let user login if credentials are correct' do
    user.password = 'test'
    user.save
    post 'api/session', params: { session: { email: 'ivicatodoric@mail.com',
                                             password: 'test' } }.to_json,
                        headers: { 'Content-Type': 'application/json',
                                   'Accept': 'application/json' }

    expect(response).to have_http_status(:ok)
  end

  it 'returns errors if credentials are incorrect' do
    user.password = 'test'
    user.save
    post 'api/session', params: { session: { email: 'ivicatodoric@mail.com',
                                             password: 'krivi' } }.to_json,
                        headers: { 'Content-Type': 'application/json',
                                   'Accept': 'application/json' }

    json_body = JSON.parse(response.body)
    expect(json_body['errors']['credentials']).to include('are invalid')
  end
end
