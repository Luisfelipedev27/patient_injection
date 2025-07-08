require 'swagger_helper'

RSpec.describe 'api/v1/injections', type: :request do
  let(:patient) { create(:patient) }
  let(:Authorization) { "Bearer #{patient.api_key}" }

  path '/api/v1/injections' do
    get('List patient injections') do
      tags 'Injections'
      produces 'application/json'
      security [{ Bearer: [] }]

      response(200, 'Injections retrieved') do
        schema type: :object,
               properties: {
                 injections: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       dose: { type: :number },
                       lot_number: { type: :string },
                       drug_name: { type: :string },
                       injected_at: { type: :string, format: :date }
                     }
                   }
                 }
               }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['injections']).to be_an(Array)
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

    post('Create injection') do
      tags 'Injections'
      consumes 'application/json'
      produces 'application/json'
      security [{ Bearer: [] }]

      parameter name: :injection, in: :body, schema: {
        type: :object,
        properties: {
          injection: {
            type: :object,
            properties: {
              dose: { type: :number, example: 2.5 },
              lot_number: { type: :string, example: 'ABC123' },
              drug_name: { type: :string, example: 'Factor VIII' },
              injected_at: { type: :string, format: :date, example: '2024-01-01' }
            },
            required: ['dose', 'lot_number', 'drug_name', 'injected_at']
          }
        }
      }

      response(201, 'Injection created') do
        let(:injection) {
          { injection: {
            dose: 2.5,
            lot_number: 'ABC123',
            drug_name: 'Factor VIII',
            injected_at: '2024-01-01'
          } }
        }

        run_test!
      end

      response(422, 'Validation failed') do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               }

        let(:injection) { { injection: { dose: -1 } } }
        run_test!
      end
    end
  end
end
