class Mention < ActiveRecord::Base

  #Don't delete straightaway
  acts_as_paranoid

  #Model relationships
  belongs_to :mentionable, -> {with_deleted}, polymorphic: true
  belongs_to :mentioner, -> {with_deleted}, polymorphic: true, touch: true
  belongs_to :user, -> {with_deleted}

  #Model callbacks
  before_destroy :delete_notification

  private

  def delete_notification
    #Delete notification
    DeleteActivityJob.perform_later(self.id, self.class.to_s)
  end

end
