class SchoolAdmin < ActiveRecord::Base
  belongs_to :user, -> {with_deleted}
  belongs_to :school, -> {with_deleted}
end
