module Linkable
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: "Rails.application.routes"
    alias :h :url_helpers
  end

  def url
    h.send :"#{self.route}_url", parameterize
  end

  def path
    h.send :"#{self.route}_path", parameterize
  end

  def route
    self.class.name.parameterize
  end

  def parameterize
    self.id
  end

end