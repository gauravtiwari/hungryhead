module Feedable
  extend ActiveSupport::Concern
  included do
    # Define polymorphic association to the parent
    belongs_to :trackable, :polymorphic => true
    # Define ownership to a resource responsible for this activity
    belongs_to :user
    # Define ownership to a resource targeted by this activity
    belongs_to :recipient, :polymorphic => true
    # Serialize parameters Hash
    serialize :parameters, HashSerializer
    #Serialize JSON
    store_accessor :parameters, :verb, :meta, :unread, :badge_description
  end

end