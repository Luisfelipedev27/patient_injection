class Api::V1::PatientsController < ApplicationController
  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      render :create, status: :created
    else
      render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:treatment_schedule_days)
  end
end
