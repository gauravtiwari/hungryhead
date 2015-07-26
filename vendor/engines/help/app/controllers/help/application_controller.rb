module Help
  class ApplicationController < ActionController::Base
    #Flash messages from rails
    after_filter :prepare_unobtrusive_flash

    before_action :set_device_type
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def set_device_type
      request.variant = :phone if browser.mobile?
      request.variant = :tablet if browser.tablet?
    end

    def help_user_admin?
      current_user && current_user.admin?
    end

    helper_method :help_user_admin?

  end
end
