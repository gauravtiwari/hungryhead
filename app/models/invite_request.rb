class InviteRequest < ActiveRecord::Base

  acts_as_copy_target
  #Model Validations
  validates :email, :presence => true,
  :uniqueness => {
    :case_sensitive => false,
    message: "You have alread submitted your invite request"
  }
  validates :name, :presence => true
  validates :url, :presence => true


end
