module SiteFeedback
  class Feedback < ActiveRecord::Base
    belongs_to :user, class_name: 'User'
  end
end
