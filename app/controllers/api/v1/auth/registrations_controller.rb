module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              success: true,
              message: 'Account created successfully',
              user: user_payload(resource)
            }, status: :created
          else
            render json: {
              success: false,
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation, :name, :phone, :role)
        end

        def user_payload(user)
          {
            id: user.id,
            email: user.email,
            name: user.name,
            phone: user.phone,
            role: user.role,
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
end
