class Users::SessionsController < Devise::SessionsController
	respond_to :json
	layout 'join'
	
	def new
		super
	end

	def edit
		super
	end

	def create
		super
	end

	def destroy
		super
	end
end