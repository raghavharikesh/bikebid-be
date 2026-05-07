module Api
  module V1
    module Admin
      class BikesController < ApplicationController
        before_action :require_admin

        def index
          render_success Bike.where(status: :pending_approval)
        end

        def approve
          bike = Bike.find(params[:id])
          bike.update!(status: :live, auction_starts_at: Time.current)
          render_success bike
        end

        def reject
          bike = Bike.find(params[:id])
          bike.update!(status: :rejected, rejection_reason: params[:reason])
          render_success bike
        end

        private

        def require_admin
          render json: { error: "Admin only" }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
