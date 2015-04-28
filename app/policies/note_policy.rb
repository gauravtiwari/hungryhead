class NotePolicy < ApplicationPolicy

 def create?
  true
 end

 def update?
  record.user == current_user
 end

 def destroy?
  record.user == current_user
 end

end

