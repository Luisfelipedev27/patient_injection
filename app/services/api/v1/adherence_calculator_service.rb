module Api::V1
  class AdherenceCalculatorService
    def self.call(patient:)
      new(patient)
    end

    def initialize(patient)
      @patient = patient
      @injections = patient.injections.ordered_by_date
    end

    def calculate_score
      return 0 if @injections.empty?

      start_date = @injections.first.injected_at
      end_date = Date.today
      schedule_days = @patient.treatment_schedule_days

      expected_dates = generate_expected_dates(start_date, end_date, schedule_days)
      actual_dates = @injections.map(&:injected_at)

      calculate_adherence_percentage(expected_dates, actual_dates)
    end

    private

    def generate_expected_dates(start_date, end_date, schedule_days)
      expected_dates = []
      next_expected_date = start_date

      while next_expected_date <= end_date
        expected_dates << next_expected_date
        next_expected_date += schedule_days.days
      end

      expected_dates
    end

    def calculate_adherence_percentage(expected_dates, actual_dates)
      on_time_injections = expected_dates.count { |date| actual_dates.include?(date) }
      total_expected = expected_dates.size

      ((on_time_injections.to_f / total_expected) * 100).round(1)
    end
  end
end
