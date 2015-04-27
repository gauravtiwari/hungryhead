class Activity < ActiveRecord::Base
  include Renderable
  include Feedable
end
