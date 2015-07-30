class InviteRequest < ActiveRecord::Base

  acts_as_copy_target

  #Model Validations
  validates :email, :presence => true,
  :uniqueness => {
    :case_sensitive => false,
    message: "You have alread submitted your invite request"
  }

  enum invite_form: {institution: 0, mentor: 1, student: 2}

  validates :name, :presence => true

end
