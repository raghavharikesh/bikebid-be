module Api
  module V1
    class UsersController < ApplicationController
      def profile
        render json: { success: true, data: user_payload(current_user) }
      end

      def update
        current_user.update!(user_params)
        render json: { success: true, data: user_payload(current_user), message: 'Profile updated successfully' }
      end

      def wallet
        wallet = current_user.wallet
        render json: { success: true, data: WalletSerializer.new(wallet).serializable_hash[:data][:attributes] }
      end

      def change_password
        unless current_user.valid_password?(params[:current_password])
          return render json: { success: false, errors: ['Current password is incorrect'] }, status: :unprocessable_entity
        end
        if params[:new_password] != params[:confirm_password]
          return render json: { success: false, errors: ['Passwords do not match'] }, status: :unprocessable_entity
        end
        current_user.update!(password: params[:new_password])
        render json: { success: true, message: 'Password updated successfully' }
      end

      def mark_read
        current_user.notifications.where(read_at: nil).update_all(read_at: Time.current)
        render json: { success: true, message: 'All notifications marked as read' }
      end

      def show_settings
        render json: { success: true, settings: { notifications: true, two_factor: false } }
      end

      def settings
        render json: { success: true, message: 'Settings updated successfully' }
      end

      private

      def user_params
        params.require(:user).permit(:name, :phone, :email)
      end

      def user_payload(user)
        {
          id: user.id,
          email: user.email,
          name: user.name,
          phone: user.phone,
          role: user.role,
          status: user.status,
          first_name: user.name.split(' ').first,
          last_name: user.name.split(' ').drop(1).join(' '),
          is_verified: true,
          two_factor_enabled: false,
          created_at: user.created_at
        }
      end
    end
  end
end
