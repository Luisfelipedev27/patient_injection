module RequestSpecHelper
  def json_response
    JSON.parse(response.body)
  end

  def auth_headers(patient = nil)
    patient ||= create(:patient)
    {
      'Authorization' => "Bearer #{patient.api_key}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  def json_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  def valid_injection_params
    {
      injection: {
        dose: 2.5,
        lot_number: 'ABC123',
        drug_name: 'Factor VIII',
        injected_at: '2024-01-01'
      }
    }.to_json
  end

  def valid_patient_params
    {
      patient: {
        treatment_schedule_days: 3
      }
    }.to_json
  end
end
