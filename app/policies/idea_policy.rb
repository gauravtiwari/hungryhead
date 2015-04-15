class IdeaPolicy < ApplicationPolicy
  def update?
  	collaborator?
  end

  def index?
  	show?
  end

  def follow?
    current_user != record.user
  end

  def show?
  	if record.in_team?(current_user) || record.published? && record.everyone?
  		true
  	else
  		false 
  	end
  end

  def card?
    show?
  end

  def publish?
  	show?
  end

  def like?
    follow?
  end

  def invite_team?
  	record.user == current_user
  end

  def updates?
  	record.in_team?(current_user)
  end

  def unpublish?
  	show?
  end

  def investors?
  	show?
  end

  def comments?
    show?
  end

  def feedbackers?
    show?
  end

  def team?
    show?
  end

  def join_team?
    record.invited?(current_user)
  end
  
  def followers?
  	show?
  end

  def collaborator? 
  	record.team.include? current_user.id.to_s
  end

  def create?
    current_user.ideas_count <= 5
  end

  def new?
    true
  end

  def destroy? 
  	record.user == current_user
  end

end

