class PagesController < ApplicationController

  layout "home"
  after_action :track_visitor_events

  #Index page to handle home and after login route
  def home
  end

  #Our Story and how we got started
  def story
  end

  #For institutions
  def for_institutions
  end

  #Community rules
  def community_guidelines
    respond_to do |format|
      format.html
    end
  end

  #Terms and conditions
  def terms
    respond_to do |format|
      format.html
    end
  end

  #Gamification
  def gamification
  end

  #pricing
  def pricing
  end

  #Collaboration
  def collaboration
  end

  #Community
  def community
  end

  #Why page
  def why
  end

  #Privacy policy page
  def privacy_policy
    respond_to do |format|
      format.html
    end
  end

  def support
  end

  def cookies_policy
  end

  def how_it_works
  end

  def product
  end

  def get_started
  end

  def upgrade_browser
    render layout: "upgrade"
  end

  #Getting started page for ideas
  def learn
  end

end
