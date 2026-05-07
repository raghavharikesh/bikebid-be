module Api
  module V1
    module Admin
      class TransactionsController < ApplicationController
        before_action :require_admin

        def index
          transactions = Transaction.includes(wallet: :user).order(created_at: :desc).page(params[:page]).per(20)
          render json: { success: true, data: transactions.map { |t| TransactionSerializer.new(t).serializable_hash[:data][:attributes] } }
        end

        def approve
          transaction = Transaction.find(params[:id])
          transaction.update!(status: :completed)
          WalletService.new(transaction.wallet).credit!(transaction.amount, reference: "ADMIN-APPROVE-#{transaction.id}")
          render json: { success: true, message: 'Transaction approved!' }
        end

        def reject
          transaction = Transaction.find(params[:id])
          transaction.update!(status: :failed)
          render json: { success: true, message: 'Transaction rejected' }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end
      end
    end
  end
end
