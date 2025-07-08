require 'rails_helper'

RSpec.describe Api::V1::AdherenceCalculatorService, type: :service do
  describe '.call' do
    it 'returns service instance' do
      patient = create(:patient)
      service = described_class.call(patient: patient)
      expect(service).to be_a(described_class)
    end
  end

  describe '#calculate_score' do
    let(:patient) { create(:patient, treatment_schedule_days: 3) }

    context 'when patient has no injections' do
      it 'returns 0' do
        service = described_class.call(patient: patient)
        expect(service.calculate_score).to eq(0)
      end
    end

    context 'when patient has perfect adherence' do
      it 'returns 100%' do
        travel_to Date.parse('2024-01-10') do
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-04'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-07'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-10'))

          service = described_class.call(patient: patient)
          expect(service.calculate_score).to eq(100)
        end
      end
    end

    context 'when patient has partial adherence' do
      it 'calculates correct percentage' do
        travel_to Date.parse('2024-01-10') do
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-04'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-10'))

          service = described_class.call(patient: patient)
          expect(service.calculate_score).to eq(75)
        end
      end
    end

    context 'when patient has injections on wrong dates' do
      it 'does not count off-schedule injections' do
        travel_to Date.parse('2024-01-10') do
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-03'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-05'))

          service = described_class.call(patient: patient)
          expect(service.calculate_score).to eq(25)
        end
      end
    end

    context 'scenario matching the challenge example' do
      it 'calculates 73% adherence (8 out of 11 expected injections)' do
        travel_to Date.parse('2024-01-31') do
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-01'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-04'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-07'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-10'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-13'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-16'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-19'))
          create(:injection, patient: patient, injected_at: Date.parse('2024-01-22'))

          service = described_class.call(patient: patient)
          score = service.calculate_score

          expect(score).to eq(73)
        end
      end
    end
  end
end
