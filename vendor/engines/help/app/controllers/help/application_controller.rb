module Help
  class ApplicationController < ActionController::Base
    before_action :set_device_type

    private

    def set_device_type
      request.variant = :phone if browser.mobile?
      request.variant = :tablet if browser.tablet?
    end

  end
end
