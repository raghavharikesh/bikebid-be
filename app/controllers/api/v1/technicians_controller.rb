module Api
  module V1
    class TechniciansController < ApplicationController
      def mylistings
        bikes = Bike.joins(:inspection).where(inspections: { technician_id: current_user.id }).includes(:bids)
        render json: { success: true, data: bikes.map { |b| BikeSerializer.new(b).serializable_hash[:data][:attributes] } }
      end
    end
  end
end
