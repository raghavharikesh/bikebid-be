module Api
  module V1
    class ReviewsController < ApplicationController
      def create
        bike = Bike.find(params[:bike_id])
        review = bike.reviews.create!(user: current_user, rating: params[:rating], comment: params[:comment])
        render json: { success: true, data: { id: review.id, rating: review.rating, comment: review.comment }, message: 'Review submitted!' }, status: :created
      end
    end
  end
end
