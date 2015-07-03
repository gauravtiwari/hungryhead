module Help
  class Engine < ::Rails::Engine
    isolate_namespace Help
    config.to_prepare do
      ApplicationController.helper(::MessagesHelper)
    end
  end
end
