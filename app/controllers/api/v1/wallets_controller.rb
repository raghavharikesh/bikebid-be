module Api
  module V1
    class WalletsController < ApplicationController
      def show
        wallet = current_user.wallet
        render json: { success: true, data: WalletSerializer.new(wallet).serializable_hash[:data][:attributes] }
      end

      def deposit
        amount = params[:amount].to_d
        raise ArgumentError, 'Amount must be positive' if amount <= 0
        WalletService.new(current_user.wallet).credit!(amount, reference: "DEP-#{SecureRandom.hex(4).upcase}")
        render json: { success: true, data: WalletSerializer.new(current_user.wallet.reload).serializable_hash[:data][:attributes], message: 'Deposit successful' }
      end

      def withdraw
        amount = params[:amount].to_d
        raise ArgumentError, 'Amount must be positive' if amount <= 0
        WalletService.new(current_user.wallet).debit!(amount, reference: "WD-#{SecureRandom.hex(4).upcase}")
        render json: { success: true, data: WalletSerializer.new(current_user.wallet.reload).serializable_hash[:data][:attributes], message: 'Withdrawal successful' }
      end
    end
  end
end
