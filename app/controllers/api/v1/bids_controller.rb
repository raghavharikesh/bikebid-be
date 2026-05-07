module Api
  module V1
    class BidsController < ApplicationController
      def index
        bike = Bike.find(params[:bike_id])
        bids = bike.bids.includes(:user).order(amount: :desc)
        render json: { success: true, data: bids.map { |b| BidSerializer.new(b).serializable_hash[:data][:attributes] } }
      end

      def create
        bike = Bike.find(params[:bike_id])
        raise ArgumentError, 'Cannot bid on your own listing' if bike.seller_id == current_user.id
        bid = bike.bids.create!(user: current_user, amount: params.dig(:bid, :amount) || params[:amount])
        render json: { success: true, data: BidSerializer.new(bid).serializable_hash[:data][:attributes], message: 'Bid placed successfully!' }, status: :created
      end

      def destroy
        bid = current_user.bids.find(params[:id])
        WalletService.new(current_user.wallet).unlock!(bid.locked_amount, reference: "BID-#{bid.id}-CANCEL")
        bid.destroy!
        render json: { success: true, message: 'Bid cancelled successfully!' }
      end

      def accept
        bike = Bike.find(params[:bike_id])
        raise ArgumentError, 'Not the seller' unless bike.seller_id == current_user.id
        bid = bike.bids.find(params[:id])
        order = AuctionService.end_auction!(bike)
        render json: { success: true, data: order, message: 'Bid accepted!' }
      end

      def reject
        bike = Bike.find(params[:bike_id])
        raise ArgumentError, 'Not the seller' unless bike.seller_id == current_user.id
        bid = bike.bids.find(params[:id])
        WalletService.new(bid.user.wallet).unlock!(bid.locked_amount, reference: "BID-#{bid.id}-REJECT")
        bid.destroy!
        render json: { success: true, message: 'Bid rejected successfully!' }
      end
    end
  end
end
