module SiteFeedback
  class Feedback < ActiveRecord::Base
    include MailForm::Delivery
    append :remote_ip, :user_agent
    attributes :name, :email, :body, :attachment, :created_at
    validates_presence_of :name, :body
    validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
    belongs_to :user, class_name: 'User'

    mount_uploader :attachment, AttachmentUploader

    enum status: {created: 0, replied: 1, closed: 1}

    def headers
      {
        :to => "support@hungryhead.co",
        :from => %("#{name}" <#{email}>),
        :subject => "#{name} left a feedback for hungryhead"
      }
    end

  end
end
