module Renderable
    def text(params = {})
      k = key.split('.')
      k.unshift('activity') if k.first != 'activity'
      k = k.join('.')

      I18n.t(k, parameters.merge(params) || {})
    end

    def render(context, params = {})
      params[:i18n] and return context.render :text => self.text(params)

      partial = partial_path(*params.values_at(:partial, :partial_root))
      layout  = layout_path(*params.values_at(:layout, :layout_root))
      locals  = prepare_locals(params)

      begin
        context.render params.merge(partial: partial, layout: layout, locals: locals)
      rescue ActionView::MissingTemplate => e
        if params[:fallback] == :text
          context.render :text => self.text(params)
        elsif params[:fallback].present?
          partial = partial_path(*params.values_at(:fallback, :partial_root))
          context.render params.merge(partial: partial, layout: layout, locals: locals)
        else
          raise e
        end
      end
    end

    def partial_path(path = nil, root = nil)
      root ||= 'activities'
      path ||= self.key.to_s.gsub('.', '/')
      select_path path, root
    end

    def layout_path(path = nil, root = nil)
      path.nil? and return
      root ||= 'layouts'
      select_path path, root
    end

    def prepare_locals(params)
      locals = params.delete(:locals) || Hash.new
      prepared_parameters = prepare_parameters(params)
      locals.merge\
        activity:     self,
        parameters:   prepared_parameters
    end

    def prepare_parameters(params)
      @prepared_params ||= self.parameters.with_indifferent_access.merge(params)
    end

    private
    def select_path path, root
      [root, path].map(&:to_s).join('/')
    end
end