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
		    resource.create_activity(key: 'user.create', owner: resource, recipient: resource, params: {
				user_name: resource.name,
				verb: "joined",
				action: "hungryhead",
				user_path: profile_path(resource),
			    avatar: resource.avatar.url(:avatar)
				}
		   	)
	    	AwardBadgeJob.set(wait: 5.seconds).perform_later(resource, resource, 1, 'user_joined')
	    	profile_path(resource)
	    else
	      signed_in_root_path(resource)
	    end
  	end
end
