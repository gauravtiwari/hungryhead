# Be sure to restart your server when you modify this file.
#
# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.
#
# 'score' method may accept a block which evaluates to boolean
# (recieves the object as parameter)

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize

      score 2, :on => 'users#update' do
        user.about_me.present?
      end

      score 2, :on => 'users#update' do
        user.followers_counter.value == 5
      end

      score 1, :on => 'comments#create', to: [:commentable, :user]
      score 5, :on => 'feedbacks#create', to: [:idea]
      score 2, :on => 'investments#create', to: [:idea]
      score 1, :on => 'notes#create', to: [:user]
      score 5, :on => 'ideas#publish', to: [:student]
      score 2, :on => 'shares#create', to: [:shareable, :user]
      score 1, :on => 'votes#vote', to: [:votable, :voter]


    end
  end
end
