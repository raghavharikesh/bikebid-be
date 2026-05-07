module Api
  module V1
    class WalletsController < ApplicationController
      def show
        render_success current_user.wallet.as_json(methods: [:available])
      end

      def deposit
        WalletService.new(current_user.wallet).credit!(
          params[:amount].to_d, reference: "DEP-#{SecureRandom.hex(4).upcase}"
        )
        render_success current_user.wallet.reload
      end

      def withdraw
        WalletService.new(current_user.wallet).debit!(
          params[:amount].to_d, reference: "WD-#{SecureRandom.hex(4).upcase}"
        )
        render_success current_user.wallet.reload
      end
    end
  end
end
