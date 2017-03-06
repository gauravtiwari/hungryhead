class LocationsController < ApplicationController
  autocomplete :location, :name, full: true
end
