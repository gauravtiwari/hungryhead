class Impression < ActiveRecord::Base

  belongs_to :user
  belongs_to :impressionable
end
