module Authentication
  extend ActiveSupport::Concern

  #Login using both email and username
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def email_required?
    super && authentications.blank?
  end

  def password_required?
    super && authentications.blank?
  end

  protected

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end