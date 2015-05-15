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

      #Users related scoring
      score 2, :on => 'users#update', category: 'autobiographer' do |user|
        user.about_me.present? && user.points(category: 'autobiographer') == 0
      end

      #Comments related
      score 2, :on => 'comments#create', category: 'comment', to: [:commentable]

      #Feedbacks related
      score 5, :on => 'feedbacks#create', category: 'feedback', to: [:idea, :student]

      score 15, :on => 'feedbacks#rate', to: :user, category: 'feedback' do |feedback|
        feedback.accepted? && feedback.helpful?
      end

      score 2, :on => 'feedbacks#rate', to: :idea_owner, category: 'user' do |feedback|
        feedback.accepted?
      end

      #Investment related
      score 5, :on => 'investments#create', to: :user, category: 'investment'

      #Ideas
      score 5, :on => 'ideas#publish', to: :student, category: 'idea'

      #Share
      score 10, :on => 'shares#create', to: [:shareable, :shareable_user], category: 'share' do |share|
        share.user != share.shareable_user
      end

      #Votes
      score 5, :on => 'votes#vote', to: [:votable, :votable_user], category: 'vote' do |vote|
        vote.votable_type != "Investment" && vote.voter != vote.votable_user
      end

    end
  end
end
