module Api
  module V1
    module Admin
      class TechniciansController < ApplicationController
        before_action :require_admin

        def index
          technicians = User.where(role: :technician).order(created_at: :desc)
          render json: { success: true, data: technicians.map { |t| technician_hash(t) } }
        end

        private

        def require_admin
          render json: { success: false, message: 'Admin only' }, status: :forbidden unless current_user.admin?
        end

        def technician_hash(user)
          {
            id: user.id, email: user.email, name: user.name,
            first_name: user.name.split(' ').first,
            last_name: user.name.split(' ').drop(1).join(' '),
            phone: user.phone, role: user.role,
            is_verified: true, created_at: user.created_at
          }
        end
      end
    end
  end
end
