module Api
  module V1
    module Admin
      class WalletsController < ApplicationController
        before_action :require_admin

        def credit
          user = User.find(params[:id])
          amount = params[:amount].to_d
          WalletService.new(user.wallet).credit!(amount, reference: "ADMIN-CREDIT-#{SecureRandom.hex(4).upcase}")
          render json: { success: true, message: 'Wallet credit request sent successfully' }
        end

        def debit
          user = User.find(params[:id])
          amount = params[:amount].to_d
          WalletService.new(user.wallet).debit!(amount, reference: "ADMIN-DEBIT-#{SecureRandom.hex(4).upcase}")
          render json: { success: true, message: 'Wallet debit request sent successfully' }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
