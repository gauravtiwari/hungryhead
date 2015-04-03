class SlugRouter
  def self.to(action)
    new(action)
  end
  def initialize(action)
    @action = action
  end
  def call(env)
    params = env['action_dispatch.request.path_parameters']
    params[:action] = @action

    sluggable = Slug.where('lower(slug) = ?', params[:slug].downcase).first
    model = sluggable.try(:sluggable_type)
    raise ActionController::RoutingError.new('Not Found') if !model

    controller = [model.pluralize.camelize,'Controller'].join
    params[:controller] = model.pluralize.downcase
    controller.constantize.action(params[:action]).call(env)
  end
end
