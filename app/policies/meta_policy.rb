class MetaPolicy < ApplicationPolicy
  
  def update?
  	create?
  end

  def follow?
    true
  end

  def show?
  	true
  end

  def comments?
    show?
  end
  
  def followers?
  	show?
  end

  def create?
    current_user.admin?
  end

  def new?
    true
  end

end

