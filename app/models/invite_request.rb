class InviteRequest < ActiveRecord::Base

  #Model Validations
  validates :email, :presence => true,
  :uniqueness => {
    :case_sensitive => false,
    message: "You have alread submitted your invite request"
  }
  validates :name, :presence => true
  validates :url, :presence => true

end
