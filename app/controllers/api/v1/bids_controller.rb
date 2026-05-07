module Api
  module V1
    class BidsController < ApplicationController
      def index
        bids = Bike.find(params[:bike_id]).bids.includes(:user).order(amount: :desc)
        render_success bids.as_json(include: { user: { only: [:id, :name] } })
      end

      def create
        bike = Bike.find(params[:bike_id])
        bid = bike.bids.create!(user: current_user, amount: params[:amount])
        render_success(bid, status: :created)
      end
    end
  end
end
