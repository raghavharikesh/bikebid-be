module Api
  module V1
    module Admin
      class InspectionsController < ApplicationController
        before_action :require_admin

        def index
          inspections = Inspection.includes(:bike, :technician).order(created_at: :desc)
          render json: { success: true, data: inspections.map { |i| InspectionSerializer.new(i).serializable_hash[:data][:attributes] } }
        end

        def approve
          inspection = Inspection.find(params[:id])
          inspection.update!(status: :completed)
          render json: { success: true, message: 'Inspection approved!' }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
