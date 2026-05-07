module Api
  module V1
    class DisputesController < ApplicationController
      def index
        disputes = current_user.disputes.includes(:order).order(created_at: :desc)
        render json: { success: true, data: disputes.map { |d| DisputeSerializer.new(d).serializable_hash[:data][:attributes] } }
      end

      def show
        dispute = current_user.disputes.find(params[:id])
        render json: { success: true, data: DisputeSerializer.new(dispute).serializable_hash[:data][:attributes] }
      end

      def create
        bike = Bike.find(params[:bike_id])
        order = bike.order
        raise ArgumentError, 'No order found for this bike' unless order
        dispute = current_user.disputes.create!(dispute_params.merge(order: order))
        render json: { success: true, data: DisputeSerializer.new(dispute).serializable_hash[:data][:attributes], message: 'Dispute raised successfully!' }, status: :created
      end

      def update
        dispute = current_user.disputes.find(params[:id])
        dispute.update!(reason: params.dig(:dispute, :description) || params[:reason])
        render json: { success: true, data: DisputeSerializer.new(dispute).serializable_hash[:data][:attributes], message: 'Dispute updated!' }
      end

      def destroy
        dispute = current_user.disputes.find(params[:id])
        dispute.destroy!
        render json: { success: true, message: 'Dispute cancelled!' }
      end

      private

      def dispute_params
        params.require(:dispute).permit(:reason)
      end
    end
  end
end
