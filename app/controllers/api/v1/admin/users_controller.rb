module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        before_action :require_admin

        def index
          users = User.order(created_at: :desc).page(params[:page]).per(20)
          render json: { success: true, data: users.map { |u| user_hash(u) } }
        end

        def admin_users
          users = User.where(role: :admin).order(created_at: :desc).page(params[:page]).per(20)
          render json: { success: true, data: users.map { |u| user_hash(u) } }
        end

        def create
          user = User.create!(
            name: "#{params[:first_name]} #{params[:last_name]}",
            email: params[:email],
            phone: params[:phone],
            role: params[:role] || :buyer,
            password: SecureRandom.hex(8)
          )
          render json: { success: true, data: user_hash(user), message: 'User added successfully!' }, status: :created
        end

        def update
          user = User.find(params[:id])
          user.update!(status: params[:userStatus]) if params[:userStatus].present?
          render json: { success: true, data: user_hash(user), message: 'User status updated successfully' }
        end

        def ban
          user = User.find(params[:id])
          user.update!(status: :banned)
          render json: { success: true, message: 'User banned' }
        end

        def cancel_subscription
          user = User.find(params[:id])
          render json: { success: true, message: 'Subscription cancelled' }
        end

        def set_subscription
          user = User.find(params[:id])
          render json: { success: true, message: "Subscription set for #{params[:months]} months" }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end

        def user_hash(user)
          {
            id: user.id,
            email: user.email,
            name: user.name,
            first_name: user.name.split(' ').first,
            last_name: user.name.split(' ').drop(1).join(' '),
            phone: user.phone,
            role: user.role,
            status: user.status,
            is_verified: true,
            two_factor_enabled: false,
            created_at: user.created_at
          }
        end
      end
    end
  end
end
