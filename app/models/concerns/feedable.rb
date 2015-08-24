module Feedable

  extend ActiveSupport::Concern
  included do
    # Define polymorphic association to the parent
    belongs_to :trackable, :polymorphic => true, touch: true
    # Define user to a resource responsible for this activity
    belongs_to :user,-> { with_deleted }, polymorphic: true, touch: true
    # Define user to a resource targeted by this activity
    belongs_to :recipient, -> { with_deleted }, :polymorphic => true, touch: true
    #Serialize JSON
    store_accessor :parameters, :verb, :meta, :unread, :badge_description
  endmk

end