# RSpec.describe 'Bookings API', type: :request do
#  let!(:bookings) { FactoryBot.create_list(:booking, 1) }
#  let(:company) { Company.create(name: 'Singapore Airlines') }
#  let(:flight) do
#    Flight.create(name: 'Zagreb - Split',
#                  departs_at: DateTime.new(2023, 2, 3, 4, 5, 0),
#                  arrives_at: DateTime.new(2023, 2, 3, 5, 0, 0),
#                  no_of_seats: 50,
#                  base_price: 750,
#                  company_id: company.id)
#  end
#  let(:user) { User.create(first_name: 'Jurko', email: 'jurko@mail.com') }
#
#  describe 'GET /bookings' do
#    it 'successfully returns a list of bookings' do
#      get '/api/bookings'
#
#      expect(response).to have_http_status(:ok)
#    end
#  end
#
#  describe 'GET /bookings/:id' do
#    it 'returns a single booking' do
#      get "/api/bookings/#{bookings.first.id}"
#
#      json_body = JSON.parse(response.body)
#
#      expect(json_body['booking']).to include('no_of_seats')
#    end
#  end
#
#  describe 'POST /bookings' do
#    context 'when params are valid' do
#      it 'creates a booking' do
#        post '/api/bookings',
#             params: { booking: { no_of_seats: 75,
#                                  seat_price: 600,
#                                  flight_id: flight.id,
#                                  user_id: user.id } }.to_json,
#             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
#
#        expect(response).to have_http_status(:created)
#        json_body = JSON.parse(response.body)
#        expect(json_body['booking']).to include('seat_price' => 600)
#      end
#    end

#    context 'when params are invalid' do
#      it 'returns 400 Bad Request' do
#        post '/api/bookings',
#             params: { booking: { seat_price: nil } }.to_json,
#             headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
#
#        expect(response).to have_http_status(:bad_request)
#        json_body = JSON.parse(response.body)
#        expect(json_body['errors']).to include('seat_price')
#      end
#    end
#  end

#  describe 'PATCH /bookings' do
#    context 'when params are valid' do
#      it 'PATCHES a bookings first_name' do
#        patch "/api/bookings/#{bookings.first.id}",
#              params: { booking: { seat_price: 650 } }.to_json,
#              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

#        expect(response).to have_http_status(:ok)
#        json_body = JSON.parse(response.body)
#        expect(json_body['booking']).to include('seat_price' => 650)
#      end
#    end

#    context 'when params are invalid' do
#      it 'returns 400 Bad Request' do
#        patch "/api/bookings/#{bookings.first.id}",
#              params: { booking: { seat_price: nil } }.to_json,
#              headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
#
#        expect(response).to have_http_status(:bad_request)
#        json_body = JSON.parse(response.body)
#        expect(json_body['errors']).to include('seat_price')
#      end
#    end
#  end

#  describe 'DELETE /bookings' do
#    it 'returns 204 No content' do
#      delete "/api/bookings/#{bookings.first.id}"
#      expect(response).to have_http_status(:no_content)
#    end
#  end
# end
