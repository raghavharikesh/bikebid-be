module Api
  module V1
    module Admin
      class BikesController < ApplicationController
        before_action :require_admin

        def index
          bikes = Bike.includes(:seller, :bids).order(created_at: :desc)
          bikes = bikes.where(status: params[:status]) if params[:status].present?
          render json: { success: true, data: bikes.map { |b| BikeSerializer.new(b).serializable_hash[:data][:attributes] } }
        end

        def approve
          bike = Bike.find(params[:id])
          bike.update!(status: :live, auction_starts_at: Time.current)
          EndAuctionJob.set(wait_until: bike.auction_ends_at).perform_later if bike.auction_ends_at
          render json: { success: true, data: BikeSerializer.new(bike).serializable_hash[:data][:attributes], message: 'Bike approved!' }
        end

        def reject
          bike = Bike.find(params[:id])
          bike.update!(status: :rejected, rejection_reason: params[:reason])
          render json: { success: true, message: 'Bike rejected' }
        end

        def qa_disable
          bike = Bike.find(params[:id])
          render json: { success: true, data: BikeSerializer.new(bike).serializable_hash[:data][:attributes], message: 'QA updated' }
        end

        def mark_sold
          bike = Bike.find(params[:id])
          bike.update!(status: :sold)
          render json: { success: true, message: 'Bike marked as sold' }
        end

        def add_slot
          bike = Bike.find(params[:id])
          render json: { success: true, message: "Slot #{params[:slot_number]} assigned to bike #{bike.id}" }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
