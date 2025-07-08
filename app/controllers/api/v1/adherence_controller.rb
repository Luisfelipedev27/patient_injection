class Api::V1::AdherenceController < ApplicationController
  before_action :authenticate_patient

  def show
    service = Api::V1::AdherenceCalculatorService.call(patient: current_patient)

    @adherence_score = service.calculate_score
  end
end
