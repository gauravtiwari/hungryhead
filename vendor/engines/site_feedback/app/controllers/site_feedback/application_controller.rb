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
      request.variant = :phone if browser.device.mobile?
      request.variant = :tablet if browser.device.tablet?
    end

    def meta_events_tracker
      @meta_events_tracker ||= MetaEvents::Tracker.new(current_user.try(:id), request.remote_ip)
    end

  end
end
