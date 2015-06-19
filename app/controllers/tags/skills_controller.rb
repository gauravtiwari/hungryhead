class SkillsController < ApplicationController

  before_filter :authenticate_user!

  autocomplete :skill, :name, :full => true

end
