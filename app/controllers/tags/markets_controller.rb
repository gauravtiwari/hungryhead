class MarketsController < ApplicationController

  before_filter :authenticate_user!

  autocomplete :market, :name, :full => true

end
