class Api::V1::InjectionsController < ApplicationController
  before_action :authenticate_patient

  def index
    @injections = current_patient.injections.ordered_by_date

    render :index
  end

  def create
    @injection = current_patient.injections.new(injection_params)

    if @injection.save
      head :created
    else
      render json: { errors: @injection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def injection_params
    params.require(:injection).permit(:dose, :lot_number, :drug_name, :injected_at)
  end
end
