class LocationsController < ApplicationController

  before_filter :authenticate_user!

  autocomplete :location, :name, :full => true

end
