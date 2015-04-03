class NotePolicy < ApplicationPolicy

  def update?
  	current_user == record.user
  end

  def show?   ; false; end
  def create? ; current_user == record.notable.user  ; end
  def destroy?; current_user == record.user; end
end

