class Users::PasswordsController < Devise::PasswordsController

	respond_to :json

	layout 'join'

	def create
		super
		@session = resource
	end

	def update
		super
	end

	def edit
		super
	end

	def new
		super
	end

	def destroy
		super
	end

end