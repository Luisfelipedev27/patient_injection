require 'swagger_helper'

RSpec.describe 'api/v1/adherence', type: :request do
  let(:patient) { create(:patient) }
  let(:Authorization) { "Bearer #{patient.api_key}" }

  path '/api/v1/adherence' do
    get('Get adherence score') do
      tags 'Adherence'
      produces 'application/json'
      security [{ Bearer: [] }]

      response(200, 'Adherence score retrieved') do
        schema type: :object,
               properties: {
                 patient_id: { type: :integer },
                 adherence_score: { type: :integer },
                 treatment_schedule_days: { type: :integer }
               }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['adherence_score']).to be_present
          expect(data['patient_id']).to eq(patient.id)
        end
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end
  end
end
