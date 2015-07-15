module Feeder
  extend ActiveSupport::Concern
  included do
    has_many :activities, -> {where(published: true)}, as: :owner, :dependent => :destroy
    cache_has_many :activities, inverse_name: :owner, embed: true
    has_many :notifications, -> {where(published: true)}, as: :owner, :dependent => :destroy
    cache_has_many :notifications, inverse_name: :owner, embed: true
  end
end