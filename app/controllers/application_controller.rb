class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :no_valid_record
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :invalid_record

  def invalid_record(exception)
    render json: ErrorSerializer.error_message(422, exception, "Unprocessable Entity"), status: :unprocessable_entity
  end

  def no_valid_record(exception)
    render json: ErrorSerializer.error_message(404, exception, "No Record Found"), status: :not_found
  end
end
