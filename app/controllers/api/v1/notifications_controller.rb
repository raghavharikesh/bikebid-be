module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        notifications = current_user.notifications.order(created_at: :desc).limit(50)
        render json: { success: true, data: notifications.map { |n| NotificationSerializer.new(n).serializable_hash[:data][:attributes] } }
      end

      def update
        notification = current_user.notifications.find(params[:id])
        notification.update!(read_at: Time.current)
        render json: { success: true, message: 'Marked as read' }
      end
    end
  end
end
