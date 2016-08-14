module Help
  class ApplicationController < ActionController::Base

    before_action :set_device_type
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def set_device_type
      request.variant = :phone if browser.device.mobile?
      request.variant = :tablet if browser.device.tablet?
    end

    def help_user_admin?
      current_user && current_user.admin?
    end

    def meta_events_tracker
      @meta_events_tracker ||= MetaEvents::Tracker.new(current_user.try(:id), request.remote_ip)
    end

    helper_method :help_user_admin?

  end
end
