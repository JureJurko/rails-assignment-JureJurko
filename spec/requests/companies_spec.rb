RSpec.describe 'Companies API', type: :request do
  let!(:companies) { FactoryBot.create_list(:company, 1) }

  describe 'GET /companies' do
    it 'successfully returns a list of companies' do
      get '/api/companies'

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /companies/:id' do
    it 'returns a single company' do
      get "/api/companies/#{companies.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body['company']).to include('name')
    end
  end

  describe 'POST /companies' do
    context 'when params are valid' do
      it 'creates a company' do
        post '/api/companies',
             params: { company: { name: 'British Airlines' } }.to_json,
             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        json_body = JSON.parse(response.body)
        expect(json_body['company']).to include('name' => 'British Airlines')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/companies',
             params: { company: { name: '' } }.to_json,
             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PATCH /companies' do
    context 'when params are valid' do
      it 'PATCHES a companies first_name' do
        patch "/api/companies/#{companies.first.id}",
              params: { company: { name: 'French Airlines' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
        json_body = JSON.parse(response.body)
        expect(json_body['company']).to include('name' => 'French Airlines')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        patch "/api/companies/#{companies.first.id}",
              params: { company: { name: nil } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'DELETE /companies' do
    it 'returns 204 No content' do
      delete "/api/companies/#{companies.first.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end
