module SiteFeedback
  class ApplicationController < ActionController::Base

    helper_method :user_signed_in?

    def user_signed_in?
      return false unless current_user
    end

  end
end
