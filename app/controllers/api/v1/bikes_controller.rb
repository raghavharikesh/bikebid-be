module Api
  module V1
    class BikesController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index, :show]

      def index
        bikes = Bike.live_auctions.includes(:seller, :bids, photos_attachments: :blob)
        bikes = bikes.where(bike_type: params[:bike_type])   if params[:bike_type].present? && Bike.bike_types.key?(params[:bike_type])
        bikes = bikes.where(fuel_type: params[:fuel_type])   if params[:fuel_type].present? && Bike.fuel_types.key?(params[:fuel_type])
        bikes = bikes.where(transmission: params[:transmission]) if params[:transmission].present? && Bike.transmissions.key?(params[:transmission])
        bikes = bikes.page(params[:page]).per(20)
        render json: { success: true, data: serialize_collection(bikes) }
      end

      def show
        bike = Bike.includes(:seller, :bids, :inspection, photos_attachments: :blob).find(params[:id])
        render json: { success: true, data: BikeSerializer.new(bike).serializable_hash[:data][:attributes] }
      end

      def create
        bike = current_user.bikes.build(bike_params.merge(status: :pending_approval))
        bike.save!
        render json: { success: true, data: BikeSerializer.new(bike).serializable_hash[:data][:attributes], message: 'Bike added successfully!' }, status: :created
      end

      def update
        bike = current_user.bikes.find(params[:id])
        bike.update!(bike_params)
        render json: { success: true, data: BikeSerializer.new(bike).serializable_hash[:data][:attributes], message: 'Bike updated successfully!' }
      end

      def mylistings
        bikes = current_user.bikes.includes(:bids, photos_attachments: :blob).order(created_at: :desc)
        render json: { success: true, data: serialize_collection(bikes) }
      end

      def buyer_bikes
        bike_ids = current_user.bids.select(:bike_id).distinct
        bikes = Bike.where(id: bike_ids).includes(:seller, :bids, photos_attachments: :blob)
        render json: { success: true, data: serialize_collection(bikes) }
      end

      def nearby_technicians
        technicians = User.where(role: :technician)
        render json: { success: true, data: technicians.map { |t| user_hash(t) } }
      end

      def check_vin
        exists = Bike.exists?(registration_number: params[:vin])
        render json: { success: true, exists: exists }
      end

      def makes
        makes = Bike.distinct.pluck(:make).sort.map { |m| { label: m, value: m } }
        render json: { success: true, makes: makes }
      end

      def models
        models = Bike.where(make: params[:make]).distinct.pluck(:model).sort.map { |m| { label: m, value: m } }
        render json: { success: true, models: models }
      end

      def trims
        render json: { success: true, trims: [] }
      end

      def end_auction
        authorize_admin!
        bike = Bike.find(params[:id])
        order = AuctionService.end_auction!(bike)
        render json: { success: true, data: order }
      end

      def inspection_report
        bike = Bike.find(params[:id])
        render json: { success: true, data: bike.inspection&.inspection_reports }
      end

      def add_bundle
        bundle = current_user.bike_bundles.create!(bundle_params)
        render json: { success: true, data: bundle, message: 'Bundle created successfully!' }, status: :created
      end

      private

      def bike_params
        params.require(:bike).permit(
          :make, :model, :year, :engine_cc, :bike_type, :fuel_type,
          :transmission, :mileage_kmpl, :kms_driven, :starting_price,
          :min_increment, :auction_starts_at, :auction_ends_at,
          :description, :registration_number, :rc_state, photos: []
        )
      end

      def bundle_params
        params.require(:bundle).permit(:title, :description)
      end

      def serialize_collection(bikes)
        bikes.map { |b| BikeSerializer.new(b).serializable_hash[:data][:attributes] }
      end

      def user_hash(user)
        { id: user.id, name: user.name, email: user.email, phone: user.phone, role: user.role }
      end

      def authorize_admin!
        render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
      end
    end
  end
end
