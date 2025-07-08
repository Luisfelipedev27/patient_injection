require 'swagger_helper'

RSpec.describe 'api/v1/patients', type: :request do
  path '/api/v1/patients' do
    post('Create a new patient') do
      tags 'Patients'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :patient, in: :body, schema: {
        type: :object,
        properties: {
          patient: {
            type: :object,
            properties: {
              treatment_schedule_days: { type: :integer, example: 3 }
            },
            required: [ 'treatment_schedule_days' ]
          }
        },
        required: [ 'patient' ]
      }

      response(201, 'Patient created successfully') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 api_key: { type: :string },
                 treatment_schedule_days: { type: :integer }
               }

        let(:patient) { { patient: { treatment_schedule_days: 3 } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to be_present
          expect(data['api_key']).to be_present
        end
      end

      response(422, 'Validation failed') do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               }

        let(:patient) { { patient: { treatment_schedule_days: -1 } } }

        run_test!
      end
    end
  end
end
