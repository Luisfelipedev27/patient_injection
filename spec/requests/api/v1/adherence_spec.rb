require 'rails_helper'

RSpec.describe 'Api::V1::Adherence', type: :request do
  let(:patient) { create(:patient) }
  let(:headers) { auth_headers(patient) }

  describe 'GET /api/v1/adherence' do
    context 'with authenticated patient' do
      it 'returns adherence data' do
        create(:injection, patient: patient)

        get '/api/v1/adherence', headers: headers

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq('patient_id' => patient.id, 'adherence_score' => 100, 'treatment_schedule_days' => 3)
      end

      it 'returns 0 adherence score when no injections' do
        get '/api/v1/adherence', headers: headers

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq('patient_id' => patient.id, 'adherence_score' => 0, 'treatment_schedule_days' => 3)
      end

      it 'calculates adherence score correctly' do
        travel_to Date.parse('2024-01-10') do
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-04'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-07'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-10'))

          get '/api/v1/adherence', headers: headers

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq('patient_id' => patient.id, 'adherence_score' => 100, 'treatment_schedule_days' => 3)
        end
      end

      it 'handles partial adherence' do
        travel_to Date.parse('2024-01-10') do
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-04'))

          create(:injection, patient: patient, injected_at: Date.parse('2024-01-10'))

          get '/api/v1/adherence', headers: headers

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq('patient_id' => patient.id, 'adherence_score' => 75, 'treatment_schedule_days' => 3)
        end
      end

      it 'works with different treatment schedules' do
        weekly_patient = create(:patient, treatment_schedule_days: 7)
        weekly_headers = auth_headers(weekly_patient)

        travel_to Date.parse('2024-01-15') do
          create(:injection, patient: weekly_patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: weekly_patient, injected_at: Date.parse('2024-01-08'))
          create(:injection, patient: weekly_patient, injected_at: Date.parse('2024-01-15'))

          get '/api/v1/adherence', headers: weekly_headers

          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq('patient_id' => weekly_patient.id, 'adherence_score' => 100, 'treatment_schedule_days' => 7)
        end
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        get '/api/v1/adherence', headers: json_headers

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end

    context 'with invalid API key' do
      it 'returns unauthorized error' do
        invalid_headers = { 'Authorization' => 'Bearer invalid_key', 'Content-Type' => 'application/json' }

        get '/api/v1/adherence', headers: invalid_headers

        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
