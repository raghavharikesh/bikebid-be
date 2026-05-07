module Api
  module V1
    class BikeQuestionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index]

      def index
        bike = Bike.find(params[:bike_id])
        questions = bike.bike_questions.includes(:user).order(created_at: :desc)
        render json: { success: true, data: questions.map { |q| question_hash(q) } }
      end

      def create
        bike = Bike.find(params[:bike_id])
        question = bike.bike_questions.create!(user: current_user, content: params.dig(:bike_question, :content))
        render json: { success: true, data: question_hash(question), message: 'Question submitted!' }, status: :created
      end

      def update
        bike = Bike.find(params[:bike_id])
        question = bike.bike_questions.find(params[:id])
        raise ArgumentError, 'Only seller can answer' unless bike.seller_id == current_user.id
        question.update!(answer: params.dig(:bike_question, :answer))
        render json: { success: true, data: question_hash(question), message: 'Answered successfully!' }
      end

      private

      def question_hash(q)
        {
          id: q.id,
          content: q.content,
          answer: q.answer,
          created_at: q.created_at,
          user: { id: q.user_id, name: q.user.name }
        }
      end
    end
  end
end
