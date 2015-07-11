module SiteFeedback
  class Feedback < ActiveRecord::Base
    include MailForm::Delivery
    append :remote_ip, :user_agent, :session
    attributes :name, :email, :body, :created_at
    validates_presence_of :name, :email, :body
    belongs_to :user, class_name: 'User'

    def headers
      {
        :to => "gaurav@gauravtiwari.co.uk",
        :subject => "#{name} left a feedback for hungryhead"
      }
    end

  end
end
