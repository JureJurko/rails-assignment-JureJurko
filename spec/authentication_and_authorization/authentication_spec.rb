RSpec.describe 'Authentication' do
  let!(:user) { FactoryBot.create(:user, token: 'abc') }

  describe 'GET/users' do
    context 'when token is valid' do
      it 'returns unauthorized request' do # mora biti admin, a ovdje je public
        get '/api/users'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when token is invalid' do
      it 'return unauthorized request' do
        user.token = nil
        get '/api/users'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is admin' do
      it 'returns list of all users' do
        user.role = 'admin'
        user.save

        get '/api/users'

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET/users/id' do
    context 'when token and user is valid' do
      it 'returns a single user' do
        user.save
        get "api/users/#{user.id}"

        expect(json_body['user']).to include('first_name' => 'Ivica')
      end
    end

    context 'when user or token is invalid' do
      it 'returns unauthorized request' do
        get "api/users/#{users.first}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is admin' do
      it 'returns a single user' do
        user.role = 'admin'
        user.save

        get "api/users/#{users.first}"

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /users' do
    context 'when params are valid' do
      it 'creates a user' do
        post '/api/users',
             params: { user: { first_name: 'Ivan', email: 'ivan@fer.hr', password: 't' } }.to_json,
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

  describe 'PATCH/users' do
    context 'when user is patching himself' do
      it 'patches users attributes' do
        user.save
        patch "api/users/#{user.id}",
              params: { user: { first_name: 'Davor' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is trying to patch another user' do
      it 'returns unauthorized request' do
        patch "api/users/#{users.first}",
              params: { user: { first_name: 'Davor' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is admin' do
      it 'patches any user' do
        user.role = 'admin'
        user.save

        patch "api/users/#{users.first}",
              params: { user: { first_name: 'Davor' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DESTROY/users/id' do
    context 'when user wants to delete himself' do
      it 'deletes himself' do
        user.save
        destroy "api/users/#{user.id}"

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user tries to delete other user' do
      it 'returns unauthorized request' do
        user.save
        destroy "api/users/#{users.first}"

        expect(repsonse).to have_http_status(:unauthorized)
      end
    end

    context 'when user is admin' do
      it 'deletes anyone' do
        user.role = 'admin'
        user.save

        destroy "api/users/#{users.first}"

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
