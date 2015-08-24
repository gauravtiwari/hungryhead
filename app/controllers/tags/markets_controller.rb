class MarketsController < ApplicationController
  autocomplete :market, :name, :full => true
end
