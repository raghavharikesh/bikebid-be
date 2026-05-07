module Api
  module V1
    class OrdersController < ApplicationController
      def index
        orders = current_user.orders.includes(:bike, :payment).order(created_at: :desc)
        render json: { success: true, data: orders.map { |o| OrderSerializer.new(o).serializable_hash[:data][:attributes] } }
      end

      def show
        order = current_user.orders.find(params[:id])
        render json: { success: true, data: OrderSerializer.new(order).serializable_hash[:data][:attributes] }
      end

      def pay
        order = current_user.orders.find(params[:id])
        raise ArgumentError, 'Order already paid' unless order.pending_payment?
        raise ArgumentError, 'Payment deadline passed' if order.overdue?

        ActiveRecord::Base.transaction do
          WalletService.new(current_user.wallet).debit!(order.total_amount, reference: "PAY-ORDER-#{order.id}")
          seller_wallet = order.bike.seller.wallet
          WalletService.new(seller_wallet).credit!(order.total_amount, reference: "SALE-ORDER-#{order.id}")
          order.update!(status: :paid)
          order.bike.update!(status: :sold)
          Payment.create!(order: order, amount: order.total_amount, status: :success, gateway: 'wallet', gateway_ref: "PAY-ORDER-#{order.id}")
        end

        render json: { success: true, data: OrderSerializer.new(order.reload).serializable_hash[:data][:attributes], message: 'Payment successful' }
      end
    end
  end
end
