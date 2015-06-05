class InviteRequest < ActiveRecord::Base

  #Model Validations
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  validates :url, :presence => true

end
