module Feeder
  extend ActiveSupport::Concern
  included do
    has_many :activities, -> {where(published: true)}, as: :owner, :dependent => :destroy
    has_many :notifications, -> {where(published: true)}, as: :owner, :dependent => :destroy
  end
end