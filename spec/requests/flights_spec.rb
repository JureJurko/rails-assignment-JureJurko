RSpec.describe 'Flights API', type: :request do
  let!(:flights) { FactoryBot.create_list(:flight, 1) }
  let(:company)  { Company.create(name: 'Singapore Airlines') }

  describe 'GET /flights' do
    it 'successfully returns a list of flights' do
      get '/api/flights'

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /flights/:id' do
    it 'returns a single flight' do
      get "/api/flights/#{flights.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body['flight']).to include('name')
    end
  end

  describe 'POST /flights' do
    context 'when params are valid' do
      it 'creates a flight' do
        post '/api/flights',
             params: { flight: { name: 'Zagreb - Vienna',
                                 departs_at: DateTime.new(2022, 10, 12, 0, 0, 0),
                                 arrives_at: DateTime.new(2022, 10, 12, 5, 45, 0),
                                 base_price: 750, no_of_seats: 50,
                                 company_id: company.id } }.to_json,
             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:created)
        json_body = JSON.parse(response.body)
        expect(json_body['flight']).to include('name' => 'Zagreb - Vienna')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights',
             params: { flight: { name: '', departs_at: nil } }.to_json,
             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body['errors']).to include('name',
                                               'departs_at',
                                               'arrives_at',
                                               'no_of_seats',
                                               'base_price')
      end
    end
  end

  describe 'PATCH /flights' do
    context 'when params are valid' do
      it 'PATCHES a flights first_name' do
        patch "/api/flights/#{flights.first.id}",
              params: { flight: { name: 'French Airlines' } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
        json_body = JSON.parse(response.body)
        expect(json_body['flight']).to include('name' => 'French Airlines')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        patch "/api/flights/#{flights.first.id}",
              params: { flight: { name: nil, departs_at: DateTime.new(2023, 10, 12) } }.to_json,
              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body['errors']).to include('name', 'departs_at')
      end
    end
  end

  describe 'DELETE /flights' do
    it 'returns 204 No content' do
      delete "/api/flights/#{flights.first.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end
