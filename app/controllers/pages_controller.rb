class PagesController < ApplicationController

  layout "home"
  before_action :set_cache, except: [:home, :get_started]

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
  def privacy
    respond_to do |format|
      format.html
    end
  end

  def support
  end

  def cookies
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

  private

  def set_cache
    fresh_when(:etag => cache_key, :last_modified => last_modified_date, :public => true)
  end

  def cache_key
    logged_in = user_signed_in? ? 'logged_in' + current_user.updated_at.try(:to_s, :number) : 'guest_user'
    browser.to_s + logged_in
  end

  def last_modified_date
    return "Sun, 03 Aug 2015".to_date unless user_signed_in? && current_user.updated_at.try(:to_s, :number)
  end

end
