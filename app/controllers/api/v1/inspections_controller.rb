module Api
  module V1
    class InspectionsController < ApplicationController
      def index
        inspections = if current_user.technician?
          Inspection.where(technician: current_user).includes(:bike, :technician)
        else
          Inspection.joins(:bike).where(bikes: { seller_id: current_user.id }).includes(:bike, :technician)
        end
        render json: { success: true, data: inspections.map { |i| InspectionSerializer.new(i).serializable_hash[:data][:attributes] } }
      end

      def show
        inspection = Inspection.find(params[:id])
        render json: { success: true, data: InspectionSerializer.new(inspection).serializable_hash[:data][:attributes] }
      end

      def create
        bike = Bike.find(inspection_params[:bike_id])
        inspection = bike.create_inspection!(
          technician_id: inspection_params[:technician_id],
          scheduled_at: inspection_params[:scheduled_at],
          status: :scheduled
        )
        render json: { success: true, data: InspectionSerializer.new(inspection).serializable_hash[:data][:attributes], message: 'Inspection scheduled!' }, status: :created
      end

      def update
        inspection = Inspection.find(params[:id])
        inspection.update!(inspection_update_params)
        if params[:reports].present?
          params[:reports].each do |r|
            inspection.inspection_reports.create!(category: r[:category], severity: r[:severity], remarks: r[:remarks])
          end
        end
        render json: { success: true, data: InspectionSerializer.new(inspection.reload).serializable_hash[:data][:attributes], message: 'Inspection updated!' }
      end

      def submit_report
        inspection = Inspection.find(params[:id])
        raise ArgumentError, 'Only assigned technician can submit' unless inspection.technician_id == current_user.id || current_user.admin?
        params[:reports].each do |r|
          inspection.inspection_reports.create!(category: r[:category], severity: r[:severity], remarks: r[:remarks])
        end
        inspection.update!(status: :completed)
        render json: { success: true, message: 'Report submitted!' }
      end

      private

      def inspection_params
        params.require(:inspection).permit(:bike_id, :technician_id, :scheduled_at, :notes)
      end

      def inspection_update_params
        params.require(:inspection).permit(:status, :notes, :technician_id, :scheduled_at)
      end
    end
  end
end
