require 'rails_helper'

RSpec.describe Injection, type: :model do
  describe 'associations' do
    it { should belong_to(:patient) }
  end

  describe 'validations' do
    it { should validate_presence_of(:dose) }
    it { should validate_numericality_of(:dose).is_greater_than(0) }
    it { should validate_presence_of(:lot_number) }
    it { should validate_length_of(:lot_number).is_equal_to(6) }
    it { should validate_presence_of(:drug_name) }
    it { should validate_presence_of(:injected_at) }
  end

  describe 'lot_number format validation' do
    it 'accepts valid alphanumeric lot numbers' do
      injection = build(:injection, lot_number: 'ABC123')
      expect(injection).to be_valid
    end

    it 'accepts numbers only' do
      injection = build(:injection, lot_number: '123456')
      expect(injection).to be_valid
    end

    it 'accepts letters only' do
      injection = build(:injection, lot_number: 'ABCDEF')
      expect(injection).to be_valid
    end

    it 'rejects lot numbers with special characters' do
      injection = build(:injection, lot_number: 'ABC-12')
      expect(injection).not_to be_valid
    end

    it 'rejects lot numbers with spaces' do
      injection = build(:injection, lot_number: 'ABC 12')
      expect(injection).not_to be_valid
    end

    it 'rejects lot numbers shorter than 6 characters' do
      injection = build(:injection, lot_number: 'ABC12')
      expect(injection).not_to be_valid
    end

    it 'rejects lot numbers longer than 6 characters' do
      injection = build(:injection, lot_number: 'ABC1234')
      expect(injection).not_to be_valid
    end
  end

  describe 'scopes' do
    describe '.ordered_by_date' do
      it 'orders injections by injected_at date' do
        patient = create(:patient)
        injection1 = create(:injection, patient: patient, injected_at: 3.days.ago)
        injection2 = create(:injection, patient: patient, injected_at: 1.day.ago)
        injection3 = create(:injection, patient: patient, injected_at: 2.days.ago)

        expect(patient.injections.ordered_by_date).to eq([ injection1, injection3, injection2 ])
      end
    end
  end
end
