class SubjectsController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :subject, :name, :full => true
end
