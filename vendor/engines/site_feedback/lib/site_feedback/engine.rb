module SiteFeedback
  class Engine < ::Rails::Engine
    isolate_namespace SiteFeedback
    config.to_prepare do
      ApplicationController.helper(::ApplicationHelper)
    end
  end
end
