module Api
  module V1
    class BikesController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index, :show]

      def index
        bikes = Bike.live_auctions
                    .where(filter_params.compact)
                    .page(params[:page]).per(20)
        render_success bikes.as_json(include: [:bike_images])
      end

      def show
        bike = Bike.find(params[:id])
        render_success bike.as_json(include: [:bike_images, :inspection])
      end

      def create
        bike = current_user.bikes.build(bike_params.merge(status: :pending_approval))
        bike.save!
        render_success(bike, status: :created)
      end

      def end_auction
        bike = Bike.find(params[:id])
        order = AuctionService.end_auction!(bike)
        render_success(order)
      end

      def inspection_report
        bike = Bike.find(params[:id])
        render_success bike.inspection&.inspection_reports
      end

      private

      def bike_params
        params.require(:bike).permit(:make, :model, :year, :engine_cc, :bike_type, :fuel_type,
                                     :transmission, :mileage_kmpl, :kms_driven, :starting_price,
                                     :min_increment, :auction_starts_at, :auction_ends_at,
                                     :description, :registration_number, :rc_state)
      end

      def filter_params
        params.permit(:bike_type, :fuel_type, :transmission)
      end
    end
  end
end
