class ApplicationController < ActionController::API
  helper_method :current_patient

  private

  def authenticate_patient
    api_key = request.headers['Authorization']&.gsub('Bearer ', '')
    @current_patient = Patient.find_by(api_key: api_key) if api_key.present?

    unless @current_patient
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_patient
    @current_patient
  end
end
