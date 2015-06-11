class RolesController < ApplicationController

  autocomplete :role, :name, :full => true

  # GET /schools
  # GET /schools.json
  def index
    @schools = School.paginate(:page => params[:page], :per_page => 12)
  end

end
