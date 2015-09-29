class SlugRouter

  # SlugRouter class to route a request to a controller action
  #   Parameters [:slug]
  # Vanity urls

  def self.to(action)
    new(action)
  end

  def initialize(action)
    @action = action
  end

  def call(env)
    params = env['action_dispatch.request.path_parameters']
    params[:action] = @action

    # Find slug in slugs
    sluggable = Slug.where('lower(slug) = ?', params[:slug].downcase).first
    model = sluggable.try(:sluggable_type)

    # Raise exception if not found
    raise ActionController::RoutingError.new('Not Found') if !model

    # If Matched pass it to controller
    controller = [model.pluralize.camelize,'Controller'].join
    params[:controller] = model.pluralize.downcase
    controller.constantize.action(params[:action]).call(env)
  end

end
