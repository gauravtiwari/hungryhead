module SiteFeedback
  class Feedback < ActiveRecord::Base
    validates_presence_of :name, :email, :body
    belongs_to :user, class_name: 'User'
  end
end
