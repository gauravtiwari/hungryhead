class Vote < ActiveRecord::Base
	belongs_to :votable, :polymorphic => true
	belongs_to :user, dependent: :destroy
	
	include Redis::Objects
	set :voters
end
