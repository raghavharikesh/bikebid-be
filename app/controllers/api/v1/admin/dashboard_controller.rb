module Api
  module V1
    module Admin
      class DashboardController < ApplicationController
        before_action :require_admin

        def show
          render json: {
            success: true,
            data: {
              users_count: User.count,
              bikes_count: Bike.count,
              live_auctions: Bike.live.count,
              pending_bikes: Bike.pending_approval.count,
              total_bids: Bid.count,
              open_disputes: Dispute.open.count,
              pending_transactions: Transaction.pending.count,
              revenue: Transaction.completed.where(transaction_type: :credit).sum(:amount)
            }
          }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
