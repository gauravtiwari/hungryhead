class PagesController < ApplicationController

  caches_action :home, :story, :community_guidelines, :terms, :why, :privacy,
  :cookies, :how_it_works, :product, :get_started, :upgrade_browser, :learn

  layout "home"

  #Index page to handle home and after login route
  def home
  end

  #Our Story and how we got started
  def story
  end

  #Community rules
  def community_guidelines
  end

  #support us
  def support_us
  end

  #Terms and conditions
  def terms
  end

  #Why page
  def why
  end

  #Privacy policy page
  def privacy
  end

  def support
  end

  def cookies
  end

  def request_invite
  end

  def how_it_works
  end

  def product
  end

  def get_started
  end

  def upgrade_browser
  end

  #Getting started page for ideas
  def learn
  end

end
