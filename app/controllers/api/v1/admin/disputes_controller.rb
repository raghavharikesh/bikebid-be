module Api
  module V1
    module Admin
      class DisputesController < ApplicationController
        before_action :require_admin

        def index
          disputes = Dispute.includes(:user, :order).order(created_at: :desc)
          render json: { success: true, data: disputes.map { |d| DisputeSerializer.new(d).serializable_hash[:data][:attributes] } }
        end

        def resolve
          dispute = Dispute.find(params[:id])
          dispute.update!(status: :resolved, resolution: params.dig(:dispute, :resolution) || params[:resolution])
          render json: { success: true, data: DisputeSerializer.new(dispute).serializable_hash[:data][:attributes], message: 'Dispute resolved!' }
        end

        def update
          dispute = Dispute.find(params[:id])
          dispute.update!(status: params.dig(:dispute, :status) || params[:status])
          render json: { success: true, data: DisputeSerializer.new(dispute).serializable_hash[:data][:attributes], message: 'Dispute updated!' }
        end

        def destroy
          dispute = Dispute.find(params[:id])
          dispute.update!(status: :rejected)
          render json: { success: true, message: 'Dispute closed' }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
