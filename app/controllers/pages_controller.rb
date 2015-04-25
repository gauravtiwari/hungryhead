class PagesController < ApplicationController

  before_filter :check_terms
  layout "home"

  #Index page to handle home and after login route
  def index
  end

  #Our Story and how we got started
  def story
  end

  #Community rules
  def rules
  end

  #Terms and conditions
  def terms
  end

  #Privacy policy page
  def privacy
  end

  #Hello page - introduce ourselves

  def hello
  end

  #Getting started page for ideas
  def learn
  end

end
