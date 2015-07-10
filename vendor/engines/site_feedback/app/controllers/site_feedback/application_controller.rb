module SiteFeedback
  class ApplicationController < ActionController::Base

    helper_method :user_signed_in?

    def user_signed_in?
      if current_user.present?
        true
      else
        false
      end
    end

  end
end
