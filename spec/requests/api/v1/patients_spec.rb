require 'rails_helper'

RSpec.describe 'Api::V1::Patients', type: :request do
  describe 'POST /api/v1/patients' do
    context 'with valid parameters' do
      it 'returns patient data with API key' do
        post '/api/v1/patients', params: valid_patient_params, headers: json_headers

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to eq('id' => Patient.last.id, 'api_key' => Patient.last.api_key)
      end
    end

    context 'with invalid parameters' do
      it 'returns validation errors for negative schedule days' do
        params = { patient: { treatment_schedule_days: -1 } }

        post '/api/v1/patients', params: params.to_json, headers: json_headers

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to be_present
      end

      it 'returns validation errors for zero schedule days' do
        params = { patient: { treatment_schedule_days: 0 } }

        post '/api/v1/patients', params: params.to_json, headers: json_headers

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
