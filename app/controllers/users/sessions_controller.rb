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
		self.resource = warden.authenticate!(auth_options)
	  set_flash_message(:notice, :signed_in) if is_flashing_format?
	  if resource.sign_in_count == 0
	  	UserWelcomeService.new(resource, profile_path(resource)).welcome
	  end
	  sign_in(resource_name, resource)
	  yield resource if block_given?
	  render json: {location: after_sign_in_path_for(resource) }
	end

	def destroy
		super
	end

	private

	def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
    	profile_path(resource)
    else
      signed_in_root_path(resource)
    end
	end

end
