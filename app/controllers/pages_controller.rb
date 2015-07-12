class PagesController < ApplicationController

  layout "home"

  #Index page to handle home and after login route
  def home
  end

  #Our Story and how we got started
  def story
  end

  #Community rules
  def community_guidelines
    respond_to do |format|
      format.html
      format.js
    end
  end

  #Terms and conditions
  def terms
    respond_to do |format|
      format.html
      format.js
    end
  end

  #Why page
  def why
  end

  #Privacy policy page
  def privacy
    respond_to do |format|
      format.html
      format.js
    end
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
