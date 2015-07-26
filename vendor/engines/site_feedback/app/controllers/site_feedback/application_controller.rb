module SiteFeedback
  class ApplicationController < ActionController::Base

    before_action :set_device_type
    helper_method :user_signed_in?

    def user_signed_in?
      if current_user.present?
        true
      else
        false
      end
    end
    private

    def set_device_type
      request.variant = :phone if browser.mobile?
      request.variant = :tablet if browser.tablet?
    end

  end
end
