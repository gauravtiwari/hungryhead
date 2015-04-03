class Users::PasswordsController < Devise::PasswordsController
	respond_to :json
	layout 'join'
	
	def create
		super
		@session = resource
	end

	def destroy
		super
	end
end