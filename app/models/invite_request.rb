class InviteRequest < ActiveRecord::Base

  acts_as_copy_target

  #Model Validations
  validates :email, :presence => true,
  :uniqueness => {
    :case_sensitive => false,
    message: "You have already submitted your invite request"
  }
  enum user_type: {institution: 0, mentor: 1, student: 2}
  validates :name, :presence => true

end
