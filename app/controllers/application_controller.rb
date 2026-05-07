class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound,  with: -> { render json: { error: "Not found" }, status: :not_found }
  rescue_from ActiveRecord::RecordInvalid    do |e| render json: { errors: e.record.errors }, status: :unprocessable_entity end
  rescue_from Pundit::NotAuthorizedError,    with: -> { render json: { error: "Forbidden" }, status: :forbidden } if defined?(Pundit)

  def render_success(data, status: :ok)
    render json: { success: true, data: data }, status: status
  end
end
