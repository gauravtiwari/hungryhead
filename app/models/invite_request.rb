class InviteRequest < ActiveRecord::Base

  acts_as_copy_target

  include MailForm::Delivery
  append :remote_ip, :user_agent
  attributes :name, :email, :url, :created_at

  #Model Validations
  validates :email, :presence => true,
  :uniqueness => {
    :case_sensitive => false,
    message: "You have alread submitted your invite request"
  }

  enum user_type: {institution: 0, mentor: 1, student: 2}

  validates :name, :presence => true

  def headers
    {
      :to => "support@hungryhead.co",
      :subject => "Pending invite request from #{name}"
    }
  end

end
