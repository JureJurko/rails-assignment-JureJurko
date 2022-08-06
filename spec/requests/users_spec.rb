__END__
RSpec.describe 'Users API', type: :request do
  let!(:users) { FactoryBot.create_list(:user, 1) }

  describe 'GET /users' do
    it 'successfully returns a list of companies' do
      get '/api/users'

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:id' do
    it 'returns a single user' do
      get "/api/users/#{users.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body['user']).to include('first_name', 'email')
    end
  end

  describe 'POST /users' do
    context 'when params are valid' do
      it 'creates a user' do
        post '/api/users',
             params: { user: { first_name: 'Ivan', email: 'ivan@fer.hr' } }.to_json,
             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        json_body = JSON.parse(response.body)
        expect(json_body['user']).to include('first_name' => 'Ivan')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/users',
             params: { user: { first_name: '', email: 'ivan@fer.hr' } }.to_json,
             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body['errors']).to include('first_name')
      end
    end
  end

  describe 'PATCH /users' do
    context 'when params are valid' do
      it 'PATCHES a users first_name' do
        patch "/api/users/#{users.first.id}",
              params: { user: { first_name: 'Davor' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
        json_body = JSON.parse(response.body)
        expect(json_body['user']).to include('first_name' => 'Davor')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        patch "/api/users/#{users.first.id}",
              params: { user: { first_name: '', email: '' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body['errors']).to include('first_name', 'email')
      end
    end
  end

  describe 'DELETE /users' do
    it 'returns 204 No content' do
      delete "/api/users/#{users.first.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end
