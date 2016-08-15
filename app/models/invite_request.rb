class InviteRequest < ActiveRecord::Base
  acts_as_copy_target

  validates :email, :presence => true,
  :uniqueness => {
    :case_sensitive => false,
    message: "You have already submitted your invite request"
  }
  validates :name, :presence => true

  enum user_type: {institution: 0, mentor: 1, student: 2}
end
