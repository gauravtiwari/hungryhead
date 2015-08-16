module SiteFeedback
  class Feedback < ActiveRecord::Base

    validates_presence_of :name, :body
    validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
    belongs_to :user, class_name: 'User'

    mount_uploader :attachment, AttachmentUploader

    enum status: {created: 0, replied: 1, closed: 1}

  end
end
