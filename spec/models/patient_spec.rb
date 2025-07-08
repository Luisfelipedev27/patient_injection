require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'associations' do
    it { should have_many(:injections).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:patient) }
    it { should validate_uniqueness_of(:api_key) }
    it { should validate_presence_of(:treatment_schedule_days) }
    it { should validate_numericality_of(:treatment_schedule_days).is_greater_than(0) }
  end

  describe 'api_key generation' do
    it 'generates api_key on create' do
      patient = create(:patient)
      expect(patient.api_key).to be_present
    end

    it 'validates presence of api_key when not generated' do
      patient = Patient.new(treatment_schedule_days: 3)
      allow(patient).to receive(:generate_api_key)
      patient.api_key = nil
      expect(patient.valid?).to be false
      expect(patient.errors[:api_key]).to include("can't be blank")
    end
  end
end
