class HobbiesController < ApplicationController

  before_filter :authenticate_user!

  autocomplete :hobby, :name, :full => true

end
