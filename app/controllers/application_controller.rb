class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid,  with: :unprocessable
  rescue_from ArgumentError,                with: :bad_request
  rescue_from StandardError,               with: :server_error

  def render_success(data, status: :ok, message: nil)
    render json: { success: true, data: data, message: message }, status: status
  end

  def render_error(message, status: :unprocessable_entity, errors: nil)
    render json: { success: false, message: message, errors: errors }, status: status
  end

  private

  def not_found(e)
    render json: { success: false, message: e.message }, status: :not_found
  end

  def unprocessable(e)
    render json: { success: false, errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def bad_request(e)
    render json: { success: false, message: e.message }, status: :bad_request
  end

  def server_error(e)
    Rails.logger.error "#{e.class}: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    render json: { success: false, message: 'Internal server error' }, status: :internal_server_error
  end
end
