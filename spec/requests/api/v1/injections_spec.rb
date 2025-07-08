require 'rails_helper'

RSpec.describe 'Api::V1::Injections', type: :request do
  let(:patient) { create(:patient) }
  let(:headers) { auth_headers(patient) }

  describe 'POST /api/v1/injections' do
    context 'with valid parameters' do
      it 'returns success status' do
        post '/api/v1/injections', params: valid_injection_params, headers: headers

        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid parameters' do
      it 'returns validation errors for missing one parameter' do
        params = { injection: { lot_number: 'ABC123', drug_name: 'Factor VIII', injected_at: '2024-01-01' } }

        post '/api/v1/injections', params: params.to_json, headers: headers

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to be_present
        expect(JSON.parse(response.body)['errors']).to include(a_string_including('Dose'))
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        post '/api/v1/injections', params: valid_injection_params, headers: json_headers

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end

    context 'with invalid API key' do
      it 'returns unauthorized error' do
        invalid_headers = { 'Authorization' => 'Bearer invalid_key', 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        post '/api/v1/injections', params: valid_injection_params, headers: invalid_headers

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end

  describe 'GET /api/v1/injections' do
    context 'with authenticated patient' do
      it 'returns injections ordered by date' do
        create(:injection, patient: patient, injected_at: '2024-01-03')
        create(:injection, patient: patient, injected_at: '2024-01-01')
        create(:injection, patient: patient, injected_at: '2024-01-02')

        get '/api/v1/injections', headers: headers

        injections = JSON.parse(response.body)['injections']

        expect(injections[2]['injected_at']).to eq('2024-01-03')
        expect(injections[1]['injected_at']).to eq('2024-01-02')
        expect(injections[0]['injected_at']).to eq('2024-01-01')
      end

      it 'returns empty array when no injections' do
        get '/api/v1/injections', headers: headers

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['injections']).to eq([])
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/injections', headers: json_headers

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
