module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: {
            success: true,
            message: 'Logged in successfully',
            access_token: request.env['warden-jwt_auth.token'],
            user: user_payload(resource)
          }
        end

        def respond_to_on_destroy
          render json: { success: true, message: 'Logged out successfully' }
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
end
