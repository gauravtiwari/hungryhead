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
      score 2, :on => 'users#update', category: 'user' do |user|
        user.about_me.present?
      end

      score 2, :on => 'follows#create', category: 'follow' do |follow|
        follow.followable.followers_counter.value == 200 && follow.followable_type != "School"
      end

      score 5, :on => 'follows#create', category: 'follow' do |follow|
        follow.followable.followers_counter.value == 500 && follow.followable_type != "School"
      end

      score 10, :on => 'follows#create', category: 'follow' do |follow|
        follow.followable.followers_counter.value == 1000 && follow.followable_type != "School"
      end

      #Comments related
      score 1, :on => 'comments#create', to: [:commentable], category: 'comment'

      #Feedbacks related
      score 1, :on => 'feedbacks#create', category: 'feedback', to: [:idea, :student]

      score 5, :on => 'feedbacks#rate', to: :user, category: 'feedback' do |feedback|
        feedback.accepted? && feedback.helpful?
      end

      score 1, :on => 'investments#create', to: [:idea, :user], category: 'investment'

      score 1, :on => 'notes#create', to: [:user], category: 'note'

      score 5, :on => 'ideas#publish', to: [:student], category: 'idea'

      score 1, :on => 'shares#create', to: [:shareable, :shareable_user], category: 'share' do |share|
        share.user != share.shareable_user
      end

      score 5, :on => 'votes#vote', to: [:votable, :votable_user], category: 'vote' do |vote|
        vote.votable_type != "Share" || vote.votable_type != "Investment" && vote.voter != vote.votable_user
      end

    end
  end
end
